import '../../features/news/models/news_enums.dart';
import '../../features/news/models/news_item.dart';
import '../../services/rss_service.dart';

abstract class RssRemoteDataSource {
  Future<List<NewsItem>> getNewsFeed({
    required NewsLanguage language,
    required NewsCategory category,
  });
}

class RssRemoteDataSourceImpl implements RssRemoteDataSource {
  final RssService _rssService;

  RssRemoteDataSourceImpl({RssService? rssService})
      : _rssService = rssService ?? RssService();

  @override
  Future<List<NewsItem>> getNewsFeed({
    required NewsLanguage language,
    required NewsCategory category,
  }) async {
    return await _rssService.fetchNews(
      language: language,
      category: category,
    );
  }
}
