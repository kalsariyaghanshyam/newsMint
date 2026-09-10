import '../../core/repositories/rss_repository.dart';
import '../../features/news/models/news_enums.dart';
import '../../features/news/models/news_item.dart';
import '../../services/feed_url_provider.dart';
import 'news_repository.dart';
import 'rss_repository_impl.dart';

class NewsRepositoryImpl implements NewsRepository {
  final RssRepository _rssRepository;

  NewsRepositoryImpl({RssRepository? rssRepository})
      : _rssRepository = rssRepository ?? RssRepositoryImpl();

  @override
  Future<List<NewsItem>> fetchNews({
    required NewsLanguage language,
    required NewsCategory category,
  }) async {
    final primaryUrl = FeedUrlProvider.getFeedUrl(language, category);
    final fallbackUrls = FeedUrlProvider.getFallbackUrls(language, category);

    final rssItems = await _rssRepository.fetchFeedWithFallbacks(
      primaryUrl,
      fallbackUrls,
    );

    return rssItems.map((item) {
      return item.toNewsItem(
        category: category,
        language: language,
      );
    }).toList();
  }
}
