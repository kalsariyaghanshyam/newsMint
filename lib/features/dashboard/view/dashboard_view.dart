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

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardBg = theme.cardColor;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final primaryAccent = theme.colorScheme.primary;

    return Consumer<NewsController>(
      builder: (context, controller, child) {
        final trendingNews = controller.items.take(5).toList();
        final bookmarkedCount = controller.items.where((i) => i.isBookmarked).length;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            elevation: 0,
            title: Row(
              children: [
                Icon(Icons.dashboard_rounded, color: primaryAccent, size: 24),
                8.width,
                Text(AppStrings.newsDashboard, style: poppins.get18.bold.textColor(textColor)),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: edge.all16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Statistics Banner
                Container(
                  padding: edge.all16,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: radius.all16,
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(AppStrings.categoryLabel, controller.selectedCategory.getLabel(controller.selectedLanguage), Icons.category, primaryAccent, textColor, subTextColor),
                      Container(height: 30, width: 1, color: borderColor),
                      _buildStatItem(AppStrings.languageLabel, controller.selectedLanguage.displayName, Icons.language, primaryAccent, textColor, subTextColor),
                      Container(height: 30, width: 1, color: borderColor),
                      _buildStatItem(AppStrings.savedLabel, '$bookmarkedCount ${AppStrings.articlesCountSuffix}', Icons.bookmark, primaryAccent, textColor, subTextColor),
                    ],
                  ),
                ),
                20.height,

                // Quick Language Selector Chips
                Text(AppStrings.languagePreferences, style: poppins.get16.bold.textColor(textColor)),
                12.height,
                Row(
                  children: NewsLanguage.values.map((lang) {
                    final isSelected = controller.selectedLanguage == lang;
                    return GestureDetector(
                      onTap: () => controller.selectLanguage(lang),
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
                          style: isSelected ? poppins.get13.bold.white : poppins.get13.medium.textColor(textColor),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                24.height,

                // Categories Quick Grid
                Text(AppStrings.exploreCategories, style: poppins.get16.bold.textColor(textColor)),
                12.height,
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: NewsCategory.values.length,
                  itemBuilder: (context, index) {
                    final cat = NewsCategory.values[index];
                    final isSelected = controller.selectedCategory == cat;
                    return InkWell(
                      onTap: () {
                        controller.selectCategory(cat);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? primaryAccent.withValues(alpha: 0.18) : cardBg,
                          borderRadius: radius.all10,
                          border: Border.all(
                            color: isSelected ? primaryAccent : borderColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cat.getLabel(controller.selectedLanguage),
                            style: isSelected ? poppins.get12.bold.textColor(primaryAccent) : poppins.get12.medium.textColor(textColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                24.height,

                // Trending Highlights Section
                Text(AppStrings.trendingHeadlines, style: poppins.get16.bold.textColor(textColor)),
                12.height,
                trendingNews.isEmpty
                    ? Container(
                        padding: edge.all20,
                        alignment: Alignment.center,
                        child: Text(AppStrings.loadingTrendingStories, style: poppins.get13.regular.textColor(subTextColor)),
                      )
                    : Column(
                        children: trendingNews.map((item) {
                          return Container(
                            margin: edge.b10,
                            padding: edge.all12,
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: radius.all12,
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                AppImage(
                                  imagePath: item.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  borderRadius: radius.all8,
                                ),
                                12.width,
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
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color primaryAccent, Color textColor, Color? subTextColor) {
    return Column(
      children: [
        Icon(icon, color: primaryAccent, size: 20),
        6.height,
        Text(value, style: poppins.get12.bold.textColor(textColor)),
        2.height,
      ],
    );
  }
}
