import '../../features/news/models/news_enums.dart';
import '../../features/news/models/news_item.dart';

class RssItemModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime? pubDate;
  final String source;
  final String link;

  RssItemModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.pubDate,
    required this.source,
    required this.link,
  });

  /// Convert raw RSS item model to NewsItem domain model
  NewsItem toNewsItem({
    required NewsCategory category,
    required NewsLanguage language,
  }) {
    return NewsItem(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      pubDate: pubDate,
      source: source,
      link: link,
      category: category,
      language: language,
    );
  }
}
