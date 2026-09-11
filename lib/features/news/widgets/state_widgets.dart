import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/border_radius_extension.dart';
import '../../../core/extensions/edge_insets_extension.dart';
import '../../../core/extensions/spacing_extension.dart';
import '../../../core/extensions/typography_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shimmer/news_list_shimmer.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NewsListShimmer();
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.white : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: edge.all24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const Icon(
                Icons.rss_feed,
                size: 64,
                color: AppColors.brandRed,
              ),
              16.height,
              Text(
                AppStrings.failedToLoadRss,
                style: poppins.get18.bold.textColor(textColor),
              ),
              8.height,
              Text(
                message,
                textAlign: TextAlign.center,
                style: poppins.get14.regular.textColor(subTextColor),
              ),
              24.height,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(AppStrings.tryAgain, style: poppins.get14.semiBold.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: AppColors.white,
                  padding: edge.v12h8.copyWith(left: 24, right: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: radius.all20,
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

class EmptyView extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyView({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.white : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: edge.all24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.newspaper_outlined,
                size: 64,
                color: subTextColor,
              ),
              16.height,
              Text(
                AppStrings.noNewsAvailable,
                style: poppins.get18.bold.textColor(textColor),
              ),
              8.height,
              Text(
                AppStrings.noNewsCategory,
                textAlign: TextAlign.center,
                style: poppins.get14.regular.textColor(subTextColor),
              ),
              24.height,
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: Text(AppStrings.refreshFeed, style: poppins.get14.semiBold.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: AppColors.white,
                  padding: edge.v12h8.copyWith(left: 24, right: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: radius.all20,
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
