import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../extensions/border_radius_extension.dart';
import '../extensions/edge_insets_extension.dart';
import '../extensions/typography_extension.dart';
import '../theme/app_colors.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String searchQuery;

  const AppSearchBar({
    Key? key,
    required this.controller,
    this.hintText = AppStrings.searchForNews,
    required this.onChanged,
    required this.onClear,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.white : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final searchBgColor = isDark ? AppColors.surfaceDark : AppColors.backgroundLight;
    final primaryAccent = theme.colorScheme.primary;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: searchBgColor,
        borderRadius: radius.all12,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: TextField(
        controller: controller,
        style: poppins.get12.medium.textColor(textColor),
        cursorColor: primaryAccent,
        textAlignVertical: TextAlignVertical.top,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: poppins.get12.regular.textColor(subTextColor),
          prefixIcon: Icon(Icons.search_rounded, color: primaryAccent, size: 20),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: subTextColor, size: 18),
                  onPressed: () {
                    controller.clear();
                    onClear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: edge.v8.h14,
        ),
      ),
    );
  }
}
