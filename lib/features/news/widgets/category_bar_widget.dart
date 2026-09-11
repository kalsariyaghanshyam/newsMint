import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/border_radius_extension.dart';
import '../../../core/extensions/edge_insets_extension.dart';
import '../../../core/extensions/typography_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/news_controller.dart';
import '../models/news_enums.dart';

class CategoryBarWidget extends StatelessWidget {
  const CategoryBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navBg = isDark ? AppColors.primaryDark : AppColors.surfaceLight;
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Consumer<NewsController>(
      builder: (context, controller, child) {
        return Container(
          color: navBg,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: edge.v6h12,
            child: Row(
              children: List.generate(
                NewsCategory.values.length,
                (index) {
                  final category = NewsCategory.values[index];
                  final isSelected = controller.selectedCategory == category;
                  final label = category.getLabel(controller.selectedLanguage);

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.selectCategory(category);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: edge.h4,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: isSelected
                                  ? poppins.get13.bold.textColor(activeColor)
                                  : poppins.get13.medium.textColor(inactiveColor),
                            ),
                            if (isSelected) ...[
                              const SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 16,
                                decoration: BoxDecoration(
                                  color: activeColor,
                                  borderRadius: radius.all2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
