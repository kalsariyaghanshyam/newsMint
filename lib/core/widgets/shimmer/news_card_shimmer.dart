import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../extensions/border_radius_extension.dart';
import '../../extensions/spacing_extension.dart';
import 'common_shimmer.dart';

class NewsCardShimmer extends StatelessWidget {
  const NewsCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : Colors.white;

    return CommonShimmer(
      child: Container(
        width: size.width,
        height: size.height,
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Stack (~40% height) with Pill overlay skeleton
            Stack(
              clipBehavior: Clip.none,
              children: [
                ShimmerBox(
                  width: size.width,
                  height: size.height * AppConstants.cardImageHeightRatio,
                ),
                Positioned(
                  bottom: -18,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerBox(
                        width: 120,
                        height: 32,
                        borderRadius: radius.all20,
                      ),
                      Row(
                        children: [
                          ShimmerBox(
                            width: 36,
                            height: 36,
                            borderRadius: radius.all20,
                          ),
                          8.width,
                          ShimmerBox(
                            width: 36,
                            height: 36,
                            borderRadius: radius.all20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            28.height,

            // Main Content Skeleton Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Headline Skeleton
                    ShimmerBox(width: size.width * 0.9, height: 22),
                    8.height,
                    ShimmerBox(width: size.width * 0.7, height: 22),
                    18.height,

                    // Body Description Lines
                    ShimmerBox(width: size.width * 0.92, height: 14),
                    8.height,
                    ShimmerBox(width: size.width * 0.88, height: 14),
                    8.height,
                    ShimmerBox(width: size.width * 0.84, height: 14),
                    8.height,
                    ShimmerBox(width: size.width * 0.60, height: 14),

                    const Spacer(),

                    // Meta Timestamp Line Skeleton
                    ShimmerBox(width: size.width * 0.45, height: 12),
                    12.height,
                  ],
                ),
              ),
            ),

            // Bottom CTA Banner Skeleton
            ShimmerBox(
              width: size.width,
              height: 44,
            ),
          ],
        ),
      ),
    );
  }
}
