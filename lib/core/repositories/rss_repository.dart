import '../../data/models/rss_item_model.dart';

abstract class RssRepository {
  Future<List<RssItemModel>> fetchFeed(String url);
  Future<List<RssItemModel>> fetchFeedWithFallbacks(
    String primaryUrl,
    List<String> fallbackUrls,
  );
}
