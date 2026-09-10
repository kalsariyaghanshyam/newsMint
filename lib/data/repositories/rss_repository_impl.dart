import '../../core/repositories/rss_repository.dart';
import '../datasources/rss_data_source.dart';
import '../models/rss_item_model.dart';

class RssRepositoryImpl implements RssRepository {
  final RssDataSource _dataSource;

  RssRepositoryImpl({RssDataSource? dataSource})
      : _dataSource = dataSource ?? RssDataSourceImpl();

  @override
  Future<List<RssItemModel>> fetchFeed(String url) async {
    return await _dataSource.fetchFeed(url);
  }

  @override
  Future<List<RssItemModel>> fetchFeedWithFallbacks(
    String primaryUrl,
    List<String> fallbackUrls,
  ) async {
    final urlsToTry = [primaryUrl, ...fallbackUrls];

    for (final url in urlsToTry) {
      try {
        final items = await _dataSource.fetchFeed(url);
        if (items.isNotEmpty) {
          return items;
        }
      } catch (_) {
        continue;
      }
    }

    return [];
  }
}
