import 'package:flutter/material.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/feed/view/feed_view.dart';
import '../../features/news/models/news_item.dart';
import '../../features/news/widgets/news_card_widget.dart';
import '../animation/app_animations.dart';
import '../theme/app_colors.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.newsFeed:
        return SlidePageRoute(
          page: const FeedView(),
          settings: settings,
        );

      case RouteNames.articleDetails:
        final newsItem = settings.arguments as NewsItem?;
        if (newsItem != null) {
          return SlidePageRoute(
            page: Scaffold(
              backgroundColor: AppColors.black,
              appBar: AppBar(
                backgroundColor: AppColors.black,
                iconTheme: const IconThemeData(color: AppColors.white),
              ),
              body: NewsCardWidget(
                newsItem: newsItem,
                currentIndex: 0,
                totalCount: 1,
              ),
            ),
            settings: settings,
          );
        }
        return _errorRoute(settings);

      case RouteNames.initial:
      case RouteNames.home:
      default:
        return SlidePageRoute(
          page: const DashboardScreen(),
          settings: settings,
        );
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return SlidePageRoute(
      page: Scaffold(
        appBar: AppBar(title: const Text('Navigation Error')),
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
      settings: settings,
    );
  }
}
