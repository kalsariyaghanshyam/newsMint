import '../../features/news/models/news_enums.dart';
import '../../features/news/models/news_item.dart';

abstract class NewsRepository {
  Future<List<NewsItem>> fetchNews({
    required NewsLanguage language,
    required NewsCategory category,
  });
}
