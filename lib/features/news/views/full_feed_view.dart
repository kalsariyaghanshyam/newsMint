import 'package:flutter/material.dart';
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

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.black,
      body: SafeArea(
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

            // Top Floating Back Header Button
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
