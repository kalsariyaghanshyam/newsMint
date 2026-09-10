import 'package:flutter/material.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';
import '../extensions/border_radius_extension.dart';
import '../extensions/edge_insets_extension.dart';
import '../extensions/spacing_extension.dart';
import '../extensions/typography_extension.dart';
import '../theme/app_colors.dart';

class AppImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageWidget(context);

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: imageWidget,
    );
  }

  Widget _buildImageWidget(BuildContext context) {
    var path = imagePath?.trim() ?? '';

    // Fix protocol-relative URLs starting with '//'
    if (path.startsWith('//')) {
      path = 'https:$path';
    }

    // If path is empty, return App Logo Placeholder
    if (path.isEmpty) {
      return errorWidget ?? _buildAppLogoPlaceholder(context);
    }

    // 1. Check Network Image (http or https)
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildLoadingPlaceholder(context);
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildAppLogoPlaceholder(context);
        },
      );
    }

    // 2. Check Asset Image (assets/)
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildAppLogoPlaceholder(context);
        },
      );
    }

    // 3. Default fallback to App Logo Placeholder
    return errorWidget ?? _buildAppLogoPlaceholder(context);
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      color: isDark ? AppColors.surfaceDark : AppColors.borderLight,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildAppLogoPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return Container(
      width: width,
      height: height,
      color: bgColor,
      child: Center(
        child: Image.asset(
          AppAssets.logo,
          width: width != null ? (width! * 0.45).clamp(48.0, 160.0) : 72,
          height: height != null ? (height! * 0.45).clamp(48.0, 160.0) : 72,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildFallbackLogoBadge(context),
        ),
      ),
    );
  }

  Widget _buildFallbackLogoBadge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: edge.all10,
            decoration: BoxDecoration(
              color: AppColors.brandRed,
              borderRadius: radius.all12,
            ),
            child: const Icon(
              Icons.newspaper_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          6.height,
          Text(
            AppStrings.appName,
            style: poppins.get12.bold.textColor(textColor),
          ),
        ],
      ),
    );
  }
}
