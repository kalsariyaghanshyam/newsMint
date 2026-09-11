import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/border_radius_extension.dart';
import '../../../core/extensions/edge_insets_extension.dart';
import '../../../core/extensions/spacing_extension.dart';
import '../../../core/extensions/typography_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../news/controllers/news_controller.dart';
import '../../news/models/news_item.dart';
import '../../news/views/full_feed_view.dart';
import '../../search/controllers/search_query_controller.dart';

class SavedBookmarksView extends StatelessWidget {
  const SavedBookmarksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.white : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer2<NewsController, SearchQueryController>(
        builder: (context, newsController, searchController, child) {
          final allBookmarks = newsController.bookmarkedItems;
          final query = searchController.query;
          final filteredBookmarks = query.isEmpty
              ? allBookmarks
              : allBookmarks.where((item) {
                  final q = query.toLowerCase();
                  return item.title.toLowerCase().contains(q) ||
                      item.description.toLowerCase().contains(q) ||
                      item.source.toLowerCase().contains(q);
                }).toList();

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: AppColors.trans,
              statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            ),
            child: Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: theme.appBarTheme.backgroundColor,
                elevation: 0,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: textColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    6.width,
                    const Icon(
                      Icons.bookmark_rounded,
                      color: AppColors.brandRed,
                      size: 20,
                    ),
                    4.width,
                    Expanded(
                      child: Text(
                        '${AppStrings.savedBookmarks} (${allBookmarks.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: poppins.get16.bold.textColor(textColor),
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  // Search Bar for Saved Bookmarks
                  if (allBookmarks.length > 3)
                    Padding(
                      padding: edge.t4.h16,
                      child: AppSearchBar(
                        controller: TextEditingController(text: query)..selection = TextSelection.fromPosition(TextPosition(offset: query.length)),
                        searchQuery: query,
                        hintText: AppStrings.searchSavedBookmarks,
                        onChanged: (val) {
                          searchController.setQuery(val.trim());
                        },
                        onClear: () {
                          searchController.clear();
                        },
                      ),
                    ),

                  // Main Bookmarks List
                  Expanded(
                    child: filteredBookmarks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  query.isNotEmpty
                                      ? Icons.search_off_rounded
                                      : Icons.bookmark_border_rounded,
                                  size: 56,
                                  color: subTextColor,
                                ),
                                12.height,
                                Text(
                                  query.isNotEmpty
                                      ? AppStrings.noMatchingBookmarksFound
                                      : AppStrings.noSavedArticlesYet,
                                  style: poppins.get16.bold.textColor(textColor),
                                ),
                                6.height,
                                Text(
                                  query.isNotEmpty
                                      ? AppStrings.trySearchingKeywords
                                      : AppStrings.bookmarkInstruction,
                                  textAlign: TextAlign.center,
                                  style: poppins.get12.regular.textColor(subTextColor),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: edge.all16,
                            itemCount: filteredBookmarks.length,
                            itemBuilder: (context, index) {
                              final item = filteredBookmarks[index];
                              return GestureDetector(
                                onTap: () => _openSwipeableBookmarks(
                                  context,
                                  filteredBookmarks,
                                  index,
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: edge.b12,
                                      padding: edge.all12,
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: radius.all12,
                                        border: Border.all(
                                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                        ),
                                        boxShadow: isDark
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: AppColors.black.withValues(alpha: 0.03),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.source.toUpperCase(),
                                                  style: poppins.get10.bold.textColor(AppColors.brandRed),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                4.height,
                                                Text(
                                                  item.title,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: poppins.get14.semiBold.textColor(textColor),
                                                ),
                                                if (item.description.isNotEmpty) ...[
                                                  4.height,
                                                  Text(
                                                    item.description,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: poppins.get12.regular.textColor(subTextColor),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          12.width,
                                          if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
                                            AppImage(
                                              imagePath: item.imageUrl,
                                              width: 68,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              borderRadius: radius.all8,
                                            ),
                                            8.width,
                                          ],
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentGeometry.topRight,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.bookmark_rounded,
                                          color: AppColors.brandRed,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          newsController.toggleBookmark(item);
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text(AppStrings.bookmarkRemoved),
                                              duration: Duration(seconds: 1),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openSwipeableBookmarks(BuildContext context, List<NewsItem> items, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullFeedView(
          title: AppStrings.savedBookmarks,
          items: items,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}
