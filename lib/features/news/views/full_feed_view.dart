import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../reusable/stack_page_view.dart';
import '../models/news_item.dart';
import '../widgets/news_card_widget.dart';

class FullFeedView extends StatefulWidget {
  final String title;
  final List<NewsItem> items;
  final int initialIndex;

  const FullFeedView({
    Key? key,
    required this.title,
    required this.items,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<FullFeedView> createState() => _FullFeedViewState();
}

class _FullFeedViewState extends State<FullFeedView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.trans,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.black,
        body: SafeArea(
          // top: false,
          child: Stack(
            children: [
              // Swipeable Feed Items
              PageView.builder(
                scrollDirection: Axis.vertical,
                controller: _pageController,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return StackPageView(
                    controller: _pageController,
                    index: index,
                    child: NewsCardWidget(
                      newsItem: item,
                      currentIndex: index,
                      totalCount: widget.items.length,
                    ),
                  );
                },
              ),

              // Top Floating Back Header Button with generous touch target area
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(12), // Touch gesture hit area expanded
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
