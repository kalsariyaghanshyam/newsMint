import 'news_enums.dart';

class NewsItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime? pubDate;
  final String source;
  final String link;
  final NewsCategory category;
  final NewsLanguage language;
  bool isBookmarked;

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    this.pubDate,
    required this.source,
    required this.link,
    required this.category,
    required this.language,
    this.isBookmarked = false,
  });

  bool get isVideo => videoUrl != null && videoUrl!.isNotEmpty;

  NewsItem copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? videoUrl,
    DateTime? pubDate,
    String? source,
    String? link,
    NewsCategory? category,
    NewsLanguage? language,
    bool? isBookmarked,
  }) {
    return NewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      pubDate: pubDate ?? this.pubDate,
      source: source ?? this.source,
      link: link ?? this.link,
      category: category ?? this.category,
      language: language ?? this.language,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'pubDate': pubDate?.toIso8601String(),
      'source': source,
      'link': link,
      'category': category.name,
      'language': language.name,
      'isBookmarked': isBookmarked,
    };
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    NewsCategory cat = NewsCategory.topStories;
    for (final c in NewsCategory.values) {
      if (c.name == json['category']) {
        cat = c;
        break;
      }
    }

    NewsLanguage lang = NewsLanguage.english;
    for (final l in NewsLanguage.values) {
      if (l.name == json['language']) {
        lang = l;
        break;
      }
    }

    return NewsItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      pubDate: json['pubDate'] != null ? DateTime.tryParse(json['pubDate']) : null,
      source: json['source'] ?? '',
      link: json['link'] ?? '',
      category: cat,
      language: lang,
      isBookmarked: json['isBookmarked'] ?? true,
    );
  }
}
