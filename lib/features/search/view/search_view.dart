import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/border_radius_extension.dart';
import '../../../core/extensions/edge_insets_extension.dart';
import '../../../core/extensions/spacing_extension.dart';
import '../../../core/extensions/typography_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_image.dart';
import '../../news/controllers/news_controller.dart';
import '../../news/models/news_enums.dart';
import '../../news/models/news_item.dart';
import '../../news/views/full_feed_view.dart';
import '../../news/widgets/news_card_widget.dart';
import '../../news/widgets/state_widgets.dart';

class SearchView extends StatefulWidget {
  final ValueChanged<int>? onSelectTab;

  const SearchView({
    Key? key,
    this.onSelectTab,
  }) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final searchBgColor = isDark ? AppColors.surfaceDark : AppColors.backgroundLight;
    final primaryAccent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Consumer<NewsController>(
          builder: (context, controller, _) {
            return _buildContent(context, controller, isDark, textColor, subTextColor, searchBgColor, primaryAccent);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    NewsController controller,
    bool isDark,
    Color textColor,
    Color subTextColor,
    Color searchBgColor,
    Color primaryAccent,
  ) {
    final allItems = controller.items;
    final filteredItems = _searchQuery.isEmpty
        ? allItems
        : allItems.where((item) {
            final q = _searchQuery.toLowerCase();
            return item.title.toLowerCase().contains(q) ||
                item.description.toLowerCase().contains(q) ||
                item.source.toLowerCase().contains(q);
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Top Search Header Field
        Padding(
          padding: edge.all16,
          child: Container(
            decoration: BoxDecoration(
              color: searchBgColor,
              borderRadius: radius.all12,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: poppins.get14.medium.textColor(textColor),
              cursorColor: primaryAccent,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              decoration: InputDecoration(
                hintText: AppStrings.searchForNews,
                hintStyle: poppins.get14.regular.textColor(subTextColor),
                prefixIcon: Icon(Icons.search_rounded, color: primaryAccent, size: 22),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded, color: subTextColor),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: edge.v12h16,
              ),
            ),
          ),
        ),

        // 2. Main Body (Filtered Search Results or Clean Category Hub & Sections)
        Expanded(
          child: controller.state == NewsState.loading
              ? const LoadingView()
              : _searchQuery.isNotEmpty
                  ? _buildSearchResultsList(context, filteredItems, controller, isDark, textColor, subTextColor)
                  : _buildCategoryExploreHub(context, allItems, controller, isDark, textColor, subTextColor, primaryAccent),
        ),
      ],
    );
  }

  // Active search query result list
  Widget _buildSearchResultsList(
    BuildContext context,
    List<NewsItem> items,
    NewsController controller,
    bool isDark,
    Color textColor,
    Color subTextColor,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: subTextColor),
            12.height,
            Text(
              AppStrings.noMatchingStories,
              style: poppins.get16.bold.textColor(textColor),
            ),
            6.height,
            Text(
              AppStrings.trySearchingKeywords,
              style: poppins.get12.regular.textColor(subTextColor),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: edge.h16.copyWith(bottom: 12),
          child: Text(
            '${AppStrings.resultsFor} "$_searchQuery" (${items.length})',
            style: poppins.get14.bold.textColor(textColor),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: edge.h16,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildNotificationStyleCard(context, item, controller, isDark, textColor, subTextColor);
            },
          ),
        ),
      ],
    );
  }

  // Category Hub & Sections (Ask Anything / Word Wheel REMOVED)
  Widget _buildCategoryExploreHub(
    BuildContext context,
    List<NewsItem> allItems,
    NewsController controller,
    bool isDark,
    Color textColor,
    Color subTextColor,
    Color primaryAccent,
  ) {
    final notificationsList = allItems.take(5).toList();
    final insightsList = allItems.skip(5).take(5).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: edge.h16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. Clean Quick Category Shortcut Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildQuickCategoryItem(
                  icon: Icons.smartphone_rounded,
                  iconBgColor: isDark ? AppColors.surfaceDark : AppColors.quickCategoryBackground,
                  iconColor: isDark ? AppColors.accentSkyDark : AppColors.iconSkyBlue,
                  label: AppStrings.myFeed,
                  textColor: textColor,
                  onTap: () {
                    controller.selectCategory(NewsCategory.politics);
                    widget.onSelectTab?.call(1); // Navigate to Home Tab
                  },
                ),
                16.width,
                _buildQuickCategoryItem(
                  icon: Icons.newspaper_rounded,
                  iconBgColor: isDark ? AppColors.surfaceDark : AppColors.quickCategoryBackground,
                  iconColor: isDark ? AppColors.accentSkyDark : AppColors.accentSky,
                  label: AppStrings.allNews,
                  textColor: textColor,
                  onTap: () {
                    controller.selectCategory(NewsCategory.india);
                    widget.onSelectTab?.call(1); // Navigate to Home Tab
                  },
                ),
                16.width,
                _buildQuickCategoryItem(
                  icon: Icons.star_rounded,
                  iconBgColor: isDark ? AppColors.surfaceDark : AppColors.quickCategoryBackground,
                  iconColor: isDark ? AppColors.accentSkyDark : AppColors.iconSkyBlue,
                  label: AppStrings.topStories,
                  textColor: textColor,
                  onTap: () {
                    controller.selectCategory(NewsCategory.topStories);
                    widget.onSelectTab?.call(1); // Navigate to Home Tab with Top Stories
                  },
                ),
                16.width,
                _buildQuickCategoryItem(
                  icon: Icons.local_fire_department_rounded,
                  iconBgColor: isDark ? AppColors.surfaceDark : AppColors.quickCategoryBackground,
                  iconColor: isDark ? AppColors.accentSkyDark : AppColors.accentSky,
                  label: AppStrings.trending,
                  textColor: textColor,
                  onTap: () {
                    controller.selectCategory(NewsCategory.trending);
                    widget.onSelectTab?.call(1); // Navigate to Home Tab with Trending
                  },
                ),
              ],
            ),
          ),
          24.height,

          // B. Notifications Section Header (Single click = detail view, View All = full swipeable feed)
          _buildSectionHeader(
            title: AppStrings.notifications,
            primaryAccent: primaryAccent,
            textColor: textColor,
            onViewAll: () {
              if (notificationsList.isNotEmpty) {
                _openSwipeableFeed(context, AppStrings.notifications, notificationsList);
              }
            },
          ),
          12.height,

          if (notificationsList.isEmpty)
            Text(AppStrings.noNewsAvailable, style: poppins.get13.regular.textColor(subTextColor))
          else
            Column(
              children: notificationsList.map((item) {
                return _buildNotificationStyleCard(context, item, controller, isDark, textColor, subTextColor);
              }).toList(),
            ),
          20.height,

          // C. Insights Section Header (Single click = detail view, View All = full swipeable feed)
          _buildSectionHeader(
            title: AppStrings.insights,
            primaryAccent: primaryAccent,
            textColor: textColor,
            onViewAll: () {
              if (insightsList.isNotEmpty) {
                _openSwipeableFeed(context, AppStrings.insights, insightsList);
              }
            },
          ),
          12.height,

          if (insightsList.isEmpty)
            Text(AppStrings.noNewsAvailable, style: poppins.get13.regular.textColor(subTextColor))
          else
            Column(
              children: insightsList.map((item) {
                return _buildNotificationStyleCard(context, item, controller, isDark, textColor, subTextColor);
              }).toList(),
            ),
          16.height,
        ],
      ),
    );
  }

  // Quick Category Icon Widget
  Widget _buildQuickCategoryItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: radius.all16,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          8.height,
          Text(
            label,
            style: poppins.get12.semiBold.textColor(textColor),
          ),
        ],
      ),
    );
  }

  // Section Header with Underline Accent and VIEW ALL button
  Widget _buildSectionHeader({
    required String title,
    required Color primaryAccent,
    required Color textColor,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: poppins.get18.bold.textColor(textColor),
            ),
            4.height,
            Container(
              height: 3,
              width: 28,
              decoration: BoxDecoration(
                color: primaryAccent,
                borderRadius: radius.all2,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            AppStrings.viewAll,
            style: poppins.get12.bold.textColor(primaryAccent),
          ),
        ),
      ],
    );
  }

  // Card Tile (Single item click -> single item detail view)
  Widget _buildNotificationStyleCard(
    BuildContext context,
    NewsItem item,
    NewsController controller,
    bool isDark,
    Color textColor,
    Color? subTextColor,
  ) {
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return InkWell(
      onTap: () => _openArticleFullScreenSingleItem(context, item),
      borderRadius: radius.all12,
      child: Container(
        margin: edge.b12,
        padding: edge.all12,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: radius.all12,
          border: Border.all(color: borderColor),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Title & Description text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: poppins.get14.semiBold.textColor(textColor),
                  ),
                  if (item.source.isNotEmpty) ...[
                    6.height,
                    Text(
                      item.source,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: poppins.get11.medium.textColor(subTextColor!),
                    ),
                  ],
                ],
              ),
            ),
            12.width,

            // Right Thumbnail Image using AppImage
            AppImage(
              imagePath: item.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              borderRadius: radius.all12,
            ),
          ],
        ),
      ),
    );
  }

  // Single Item Detail View
  void _openArticleFullScreenSingleItem(BuildContext context, NewsItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: SafeArea(
            child: NewsCardWidget(
              newsItem: item,
              currentIndex: 0,
              totalCount: 1,
            ),
          ),
        ),
      ),
    );
  }

  // Complete List Swipeable Feed View (Opened via View All)
  void _openSwipeableFeed(BuildContext context, String title, List<NewsItem> items) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullFeedView(
          title: title,
          items: items,
        ),
      ),
    );
  }
}
