import '../core/config/app_env.dart';
import '../features/news/models/news_enums.dart';

class FeedUrlProvider {
  /// Maps (Language, Category) to RSS feed URLs
  static String getFeedUrl(NewsLanguage language, NewsCategory category) {
    switch (language) {
      case NewsLanguage.english:
        return _getEnglishUrl(category);
      case NewsLanguage.hindi:
        return _getHindiUrl(category);
      case NewsLanguage.gujarati:
        return _getGujaratiUrl(category);
    }
  }

  static String getVideoFeedUrl(NewsLanguage language) {
    switch (language) {
      case NewsLanguage.english:
        return '${AppEnv.englishRssBaseUrl}/rssfeedsvideo/3812908.cms';
      case NewsLanguage.hindi:
        return '${AppEnv.hindiRssBaseUrl}/news/india/feed';
      case NewsLanguage.gujarati:
        return '${AppEnv.gujaratiRssBaseUrl}/national/feed';
    }
  }

  static String _getEnglishUrl(NewsCategory category) {
    final base = AppEnv.englishRssBaseUrl;
    switch (category) {
      case NewsCategory.topStories:
        return '$base/rssfeedstopstories.cms';
      case NewsCategory.trending:
        return 'https://www.hindustantimes.com/feeds/rss/trending/rssfeed.xml';
      case NewsCategory.politics:
        return 'https://www.hindustantimes.com/feeds/rss/india-news/rssfeed.xml';
      case NewsCategory.india:
        return '$base/rssfeedstopstories.cms';
      case NewsCategory.gujarat:
        return '$base/rssfeeds/-2128838597.cms';
      case NewsCategory.business:
        return 'https://www.hindustantimes.com/feeds/rss/business/rssfeed.xml';
      case NewsCategory.shareMarket:
        return 'https://economictimes.indiatimes.com/markets/rssfeeds/2146842.cms';
      case NewsCategory.sports:
        return 'https://www.hindustantimes.com/feeds/rss/sports/rssfeed.xml';
      case NewsCategory.technology:
        return 'https://www.hindustantimes.com/feeds/rss/tech/rssfeed.xml';
      case NewsCategory.entertainment:
        return '$base/rssfeedsvideo/3812908.cms';
      case NewsCategory.world:
        return 'https://www.hindustantimes.com/feeds/rss/world-news/rssfeed.xml';
    }
  }

  static String _getHindiUrl(NewsCategory category) {
    final base = AppEnv.hindiRssBaseUrl;
    switch (category) {
      case NewsCategory.topStories:
        return '$base/home/feed';
      case NewsCategory.trending:
        return '$base/news/india/feed';
      case NewsCategory.politics:
        return '$base/news/india/feed';
      case NewsCategory.india:
        return '$base/news/india/feed';
      case NewsCategory.gujarat:
        return '$base/states/gujarat/feed';
      case NewsCategory.business:
        return '$base/business/feed';
      case NewsCategory.shareMarket:
        return '$base/business/personal-finance/feed';
      case NewsCategory.sports:
        return '$base/sports/feed';
      case NewsCategory.technology:
        return '$base/technology/feed';
      case NewsCategory.entertainment:
        return '$base/entertainment/feed';
      case NewsCategory.world:
        return '$base/news/world/feed';
    }
  }

  static String _getGujaratiUrl(NewsCategory category) {
    final base = AppEnv.gujaratiRssBaseUrl;
    switch (category) {
      case NewsCategory.topStories:
        return '$base/national/feed';
      case NewsCategory.trending:
        return '$base/national/feed';
      case NewsCategory.politics:
        return '$base/national/feed';
      case NewsCategory.india:
        return '$base/national/feed';
      case NewsCategory.gujarat:
        return '$base/gujarat/feed';
      case NewsCategory.business:
        return '$base/business/feed';
      case NewsCategory.shareMarket:
        return '$base/business/feed';
      case NewsCategory.sports:
        return '$base/sports/feed';
      case NewsCategory.technology:
        return '$base/technology/feed';
      case NewsCategory.entertainment:
        return '$base/entertainment/feed';
      case NewsCategory.world:
        return '$base/world/feed';
    }
  }

  static List<String> getFallbackUrls(NewsLanguage language, NewsCategory category) {
    switch (language) {
      case NewsLanguage.english:
        return [
          'https://rss.app/feeds/v1.1/googlenews.xml',
          'https://news.google.com/rss?hl=en-IN&gl=IN&ceid=IN:en',
        ];
      case NewsLanguage.hindi:
        return [
          'https://news.google.com/rss?hl=hi&gl=IN&ceid=IN:hi',
        ];
      case NewsLanguage.gujarati:
        return [
          'https://news.google.com/rss?hl=gu&gl=IN&ceid=IN:gu',
        ];
    }
  }
}
