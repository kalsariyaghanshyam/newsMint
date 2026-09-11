import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/border_radius_extension.dart';
import '../../../core/extensions/edge_insets_extension.dart';
import '../../../core/extensions/spacing_extension.dart';
import '../../../core/extensions/typography_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../news/controllers/news_controller.dart';
import '../../news/models/news_enums.dart';
import '../../news/models/news_item.dart';
import '../../news/widgets/news_card_widget.dart';
import 'saved_bookmarks_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  static const int _maxDisplayCountOnProfile = 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.white : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardBg = theme.cardColor;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final primaryAccent = theme.colorScheme.primary;

    return Consumer2<NewsController, ThemeController>(
      builder: (context, newsController, themeController, child) {
        final bookmarkedItems = newsController.bookmarkedItems;
        final visibleItems = bookmarkedItems.take(_maxDisplayCountOnProfile).toList();
        final hasMoreBookmarks = bookmarkedItems.length > _maxDisplayCountOnProfile;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: edge.all16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Language Selection Setting Section
                  Text(
                    AppStrings.languageSelection,
                    style: poppins.get15.bold.textColor(textColor),
                  ),
                  10.height,
                  Row(
                    children: NewsLanguage.values.map((lang) {
                      final isSelected = newsController.selectedLanguage == lang;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => newsController.selectLanguage(lang),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: edge.r8,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryAccent : cardBg,
                            borderRadius: radius.all20,
                            border: Border.all(
                              color: isSelected ? primaryAccent : borderColor,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: primaryAccent.withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            lang.displayName,
                            style: isSelected
                                ? poppins.get13.bold.white
                                : poppins.get13.medium.textColor(textColor),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  20.height,

                  // Theme Selection Section (Interactive Light / Dark Theme selector)
                  Text(
                    AppStrings.themeOptions,
                    style: poppins.get15.bold.textColor(textColor)
                  ),
                  10.height,
                  Row(
                    children: [
                      Expanded(
                        child: _buildThemeTile(
                          context: context,
                          title: AppStrings.darkTheme,
                          icon: Icons.dark_mode_rounded,
                          isSelected: themeController.themeMode == ThemeMode.dark,
                          onTap: () => themeController.setThemeMode(ThemeMode.dark),
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          primaryAccent: primaryAccent,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: _buildThemeTile(
                          context: context,
                          title: AppStrings.lightTheme,
                          icon: Icons.light_mode_rounded,
                          isSelected: themeController.themeMode == ThemeMode.light,
                          onTap: () => themeController.setThemeMode(ThemeMode.light),
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          primaryAccent: primaryAccent,
                        ),
                      ),
                    ],
                  ),
                  20.height,

                  // Saved Bookmarks List Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: edge.all6,
                              decoration: BoxDecoration(
                                color: AppColors.brandRed.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.bookmark_rounded, color: AppColors.brandRed, size: 16),
                            ),
                            8.width,
                            Expanded(
                              child: Text(
                                '${AppStrings.savedBookmarks} ${bookmarkedItems.length}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: poppins.get15.bold.textColor(textColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      8.width,

                      // VIEW ALL Header Action (Shown whenever bookmarks exist)
                      if (bookmarkedItems.isNotEmpty)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _openAllBookmarksPage(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppStrings.viewAll,
                                  style: poppins.get12.bold.textColor(primaryAccent),
                                ),
                                2.width,
                                Icon(Icons.chevron_right_rounded, size: 18, color: primaryAccent),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  12.height,

                  // Empty Bookmark State vs Bookmarked List
                  if (bookmarkedItems.isEmpty)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bookmark_border_rounded,
                                size: 42,
                                color: primaryAccent.withValues(alpha: 0.75),
                              ),

                              16.height,

                              Text(
                                AppStrings.noSavedArticlesYet,
                                textAlign: TextAlign.center,
                                style: poppins.get16.semiBold.textColor(textColor),
                              ),

                              6.height,

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 48),
                                child: Text(
                                  AppStrings.bookmarkInstruction,
                                  textAlign: TextAlign.center,
                                  style: poppins.get12.regular
                                      .textColor(subTextColor)
                                      .copyWith(height: 1.5),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  else ...[
                    // Strictly non-scrollable list capped at 3 items
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: visibleItems.map((item) {
                            return GestureDetector(
                              onTap: () => _openArticleFullScreen(context, item),

                              child: Container(
                                margin: edge.b10,
                                padding: edge.all10,
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: radius.all12,
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.source.toUpperCase(),
                                            style: poppins.get10.bold.textColor(AppColors.brandRed),
                                          ),
                                          2.height,
                                          Text(
                                            item.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppins.get13.semiBold.textColor(textColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.bookmark, color: AppColors.brandRed, size: 22),
                                      onPressed: () => newsController.toggleBookmark(item),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // View All Action Card if bookmarks count > 3
                    if (hasMoreBookmarks) ...[
                      4.height,
                      InkWell(
                        onTap: () => _openAllBookmarksPage(context),
                        borderRadius: radius.all12,
                        child: Container(
                          width: double.infinity,
                          padding: edge.v10h16,
                          decoration: BoxDecoration(
                            color: primaryAccent.withValues(alpha: 0.1),
                            borderRadius: radius.all12,
                            border: Border.all(
                              color: primaryAccent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${AppStrings.viewAll} (${bookmarkedItems.length} Saved Bookmarks)',
                                style: poppins.get13.bold.textColor(primaryAccent),
                              ),
                              6.width,
                              Icon(Icons.arrow_forward_rounded, size: 16, color: primaryAccent),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color primaryAccent,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: edge.all12,
        decoration: BoxDecoration(
          color: isSelected ? primaryAccent.withValues(alpha: 0.12) : cardBg,
          borderRadius: radius.all12,
          border: Border.all(
            color: isSelected ? primaryAccent : borderColor,
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryAccent : textColor,
              size: 20,
            ),
            6.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected
                        ? poppins.get11.bold.textColor(primaryAccent)
                        : poppins.get11.medium.textColor(textColor),
                  ),
                ),
                if (isSelected) ...[
                  4.width,
                  Icon(Icons.check_circle_rounded, color: primaryAccent, size: 14),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openAllBookmarksPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SavedBookmarksView(),
      ),
    );
  }

  void _openArticleFullScreen(BuildContext context, NewsItem item) {
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
}
