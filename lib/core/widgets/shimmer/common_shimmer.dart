import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../extensions/border_radius_extension.dart';

class CommonShimmer extends StatelessWidget {
  final Widget child;

  const CommonShimmer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeletonColor = isDark ? AppColors.surfaceDark : AppColors.borderLight;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: skeletonColor,
        borderRadius: borderRadius ?? radius.all4,
      ),
    );
  }
}
