import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import '../features/news/models/news_item.dart';
import '../features/news/models/news_enums.dart';
import 'feed_url_provider.dart';

class RssService {
  final http.Client _client;

  RssService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<NewsItem>> fetchNews({
    required NewsLanguage language,
    required NewsCategory category,
  }) async {
    final primaryUrl = FeedUrlProvider.getFeedUrl(language, category);
    final fallbackUrls = FeedUrlProvider.getFallbackUrls(language, category);

    final urlsToTry = [primaryUrl, ...fallbackUrls];

    for (final url in urlsToTry) {
      try {
        final items = await _fetchAndParse(url, language, category);
        if (items.isNotEmpty) {
          return items;
        }
      } catch (e) {
        continue;
      }
    }

    return [];
  }

  Future<List<NewsItem>> _fetchAndParse(
    String url,
    NewsLanguage language,
    NewsCategory category,
  ) async {
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/rss+xml, application/xml, text/xml, */*',
      },
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw Exception('Failed to load feed, status code: ${response.statusCode}');
    }

    final String xmlBody = utf8.decode(response.bodyBytes);
    final document = xml.XmlDocument.parse(xmlBody);
    final channelTitle = _extractChannelTitle(document);

    final items = <NewsItem>[];
    final itemElements = document.findAllElements('item');

    int index = 0;
    for (final element in itemElements) {
      final titleRaw = _findElementsText(element, 'title');
      final descRaw = _findElementsText(element, 'description');
      final link = _findElementsText(element, 'link');
      final pubDateRaw = _findElementsText(element, 'pubDate');
      final guid = _findElementsText(element, 'guid');

      final title = _cleanHtml(titleRaw);
      final description = _cleanHtml(descRaw);

      if (title.isEmpty) continue;

      final imageUrl = _extractImageUrl(element, descRaw);
      final videoUrl = _extractVideoUrl(element, descRaw);
      final pubDate = _parseDate(pubDateRaw);
      final source = _extractSource(element, channelTitle);

      final id = guid.isNotEmpty
          ? guid
          : (link.isNotEmpty ? link : '${category.name}_${language.name}_$index');

      items.add(
        NewsItem(
          id: id,
          title: title,
          description: description.isNotEmpty
              ? description
              : 'Tap to read full story on original source.',
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          pubDate: pubDate,
          source: source,
          link: link.isNotEmpty ? link : url,
          category: category,
          language: language,
        ),
      );
      index++;
    }

    return items;
  }

  String _extractChannelTitle(xml.XmlDocument doc) {
    try {
      final channel = doc.findAllElements('channel').firstOrNull;
      if (channel != null) {
        final title = _findElementsText(channel, 'title');
        if (title.isNotEmpty) return _cleanHtml(title);
      }
    } catch (_) {}
    return 'News';
  }

  String _findElementsText(xml.XmlElement parent, String name) {
    final nameLower = name.toLowerCase();
    for (final child in parent.children) {
      if (child is xml.XmlElement) {
        final local = child.name.local.toLowerCase();
        final qualified = child.name.qualified.toLowerCase();
        if (local == nameLower || qualified == nameLower || qualified.endsWith(':$nameLower')) {
          return child.innerText.trim();
        }
      }
    }
    final elements = parent.findElements(name);
    if (elements.isNotEmpty) {
      return elements.first.innerText.trim();
    }
    return '';
  }

  String _cleanHtml(String raw) {
    if (raw.isEmpty) return '';
    try {
      final document = html_parser.parse(raw);
      final parsedText = document.body?.text.trim() ?? '';
      if (parsedText.isNotEmpty && !parsedText.contains('<')) {
        return parsedText.replaceAll(RegExp(r'\s+'), ' ');
      }
    } catch (_) {}
    return raw.replaceAll(RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false), '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String? _extractImageUrl(xml.XmlElement element, String rawDesc) {
    // 1. Check enclosure tags
    for (final enc in element.findElements('enclosure')) {
      final url = enc.getAttribute('url');
      final type = enc.getAttribute('type') ?? '';
      if (url != null && (type.startsWith('image/') || _isImageUrl(url))) {
        return _normalizeUrl(url);
      }
    }

    // 2. Check all child elements (media:content, media:thumbnail, content, thumbnail, image, etc.)
    for (final child in element.children) {
      if (child is xml.XmlElement) {
        final localName = child.name.local.toLowerCase();
        if (localName == 'content' || localName == 'thumbnail' || localName == 'image' || localName == 'enclosure') {
          final url = child.getAttribute('url') ?? child.getAttribute('src');
          if (url != null && url.isNotEmpty) {
            return _normalizeUrl(url);
          }
        }
      }
    }

    // 3. Combine raw description and content:encoded
    final contentEncoded = _findElementsText(element, 'encoded');
    final combinedHtml = '$rawDesc $contentEncoded';

    // 4. Regex for src="..." or src='...' or data-src="..."
    final imgMatch = RegExp(
      "(?:src|data-src|url)=[\"']([^\"']+)[\"']",
      caseSensitive: false,
    ).firstMatch(combinedHtml);

    if (imgMatch != null) {
      final src = imgMatch.group(1);
      if (src != null && src.isNotEmpty) {
        final norm = _normalizeUrl(src);
        if (norm != null && norm.startsWith('http')) {
          return norm;
        }
      }
    }

    // 5. Fallback regex for generic img src in HTML
    final genericImgMatch = RegExp(
      "<img[^>]+(?:src|data-src)=[\"']([^\"']+)[\"']",
      caseSensitive: false,
    ).firstMatch(combinedHtml);

    if (genericImgMatch != null) {
      final src = genericImgMatch.group(1);
      if (src != null && src.isNotEmpty) {
        final norm = _normalizeUrl(src);
        if (norm != null && norm.startsWith('http')) {
          return norm;
        }
      }
    }

    return null;
  }

  String? _normalizeUrl(String url) {
    var trimmed = url.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('//')) {
      return 'https:$trimmed';
    }
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return null;
    }
    return trimmed;
  }

  String? _extractVideoUrl(xml.XmlElement element, String rawDesc) {
    for (final enc in element.findElements('enclosure')) {
      final url = enc.getAttribute('url');
      final type = enc.getAttribute('type') ?? '';
      if (url != null && (type.startsWith('video/') || _isVideoUrl(url))) {
        return url;
      }
    }

    for (final child in element.children) {
      if (child is xml.XmlElement && child.name.local == 'content') {
        final url = child.getAttribute('url');
        final type = child.getAttribute('type') ?? '';
        if (url != null && (type.startsWith('video/') || _isVideoUrl(url))) {
          return url;
        }
      }
    }

    final videoMatch = RegExp(r'<video[^>]+src="([^"]+)"', caseSensitive: false).firstMatch(rawDesc);
    if (videoMatch != null) {
      final src = videoMatch.group(1);
      if (src != null && src.isNotEmpty) {
        return src;
      }
    }

    final iframeMatch = RegExp(r'<iframe[^>]+src="([^"]+)"', caseSensitive: false).firstMatch(rawDesc);
    if (iframeMatch != null) {
      final src = iframeMatch.group(1);
      if (src != null && (src.contains('youtube') || src.contains('vimeo') || _isVideoUrl(src))) {
        return src;
      }
    }

    return null;
  }

  bool _isImageUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.jpg') ||
        lower.contains('.jpeg') ||
        lower.contains('.png') ||
        lower.contains('.webp') ||
        lower.contains('image');
  }

  bool _isVideoUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.mp4') ||
        lower.contains('.m3u8') ||
        lower.contains('.webm') ||
        lower.contains('youtube') ||
        lower.contains('vimeo');
  }

  DateTime? _parseDate(String rawDate) {
    if (rawDate.isEmpty) return null;
    try {
      return DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(rawDate, true);
    } catch (_) {
      try {
        return DateTime.parse(rawDate);
      } catch (_) {
        return null;
      }
    }
  }

  String _extractSource(xml.XmlElement element, String channelTitle) {
    final sourceElem = element.findElements('source').firstOrNull;
    if (sourceElem != null && sourceElem.innerText.trim().isNotEmpty) {
      return _cleanHtml(sourceElem.innerText.trim());
    }
    return channelTitle.isNotEmpty ? channelTitle : 'RSS News';
  }
}
