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

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardBg = theme.cardColor;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final primaryAccent = theme.colorScheme.primary;

    return Consumer2<NewsController, ThemeController>(
      builder: (context, newsController, themeController, child) {
        final bookmarkedItems = newsController.items.where((item) => item.isBookmarked).toList();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: edge.all16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Top Title
                  Text(
                    AppStrings.profileAndSettings,
                    style: poppins.get20.bold.textColor(textColor),
                  ),
                  20.height,

                  // Language Selection Setting Section
                  Text(
                    AppStrings.languageSelection,
                    style: poppins.get16.bold.textColor(textColor),
                  ),
                  12.height,
                  Row(
                    children: NewsLanguage.values.map((lang) {
                      final isSelected = newsController.selectedLanguage == lang;
                      return GestureDetector(
                        onTap: () => newsController.selectLanguage(lang),
                        child: Container(
                          margin: edge.r8,
                          padding: edge.v8h16,
                          decoration: BoxDecoration(
                            color: isSelected ? primaryAccent : cardBg,
                            borderRadius: radius.all20,
                            border: Border.all(
                              color: isSelected ? primaryAccent : borderColor,
                            ),
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
                  24.height,

                  // Theme Selection Section (Interactive Light / Dark Theme selector)
                  Text(
                    AppStrings.themeOptions,
                    style: poppins.get16.bold.textColor(textColor),
                  ),
                  12.height,
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
                  24.height,

                  // Saved Bookmarks List Section
                  Row(
                    children: [
                      const Icon(Icons.bookmark, color: AppColors.brandRed, size: 20),
                      8.width,
                      Text(
                        '${AppStrings.savedBookmarks} (${bookmarkedItems.length})',
                        style: poppins.get16.bold.textColor(textColor),
                      ),
                    ],
                  ),
                  12.height,

                  if (bookmarkedItems.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: edge.all24,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: radius.all12,
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.bookmark_border, size: 40, color: subTextColor),
                          8.height,
                          Text(
                            AppStrings.noSavedArticlesYet,
                            style: poppins.get14.bold.textColor(textColor),
                          ),
                          4.height,
                          Text(
                            AppStrings.bookmarkInstruction,
                            textAlign: TextAlign.center,
                            style: poppins.get12.regular.textColor(subTextColor),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: bookmarkedItems.map((item) {
                        return InkWell(
                          onTap: () => _openArticleFullScreen(context, item),
                          borderRadius: radius.all12,
                          child: Container(
                            margin: edge.b10,
                            padding: edge.all12,
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
                                      4.height,
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
                                  icon: const Icon(Icons.bookmark, color: AppColors.brandRed),
                                  onPressed: () => newsController.toggleBookmark(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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
        padding: edge.all14,
        decoration: BoxDecoration(
          color: isSelected ? primaryAccent.withValues(alpha: 0.12) : cardBg,
          borderRadius: radius.all12,
          border: Border.all(
            color: isSelected ? primaryAccent : borderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryAccent : textColor,
              size: 26,
            ),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: isSelected
                      ? poppins.get13.bold.textColor(primaryAccent)
                      : poppins.get13.medium.textColor(textColor),
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
