import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../../core/animation/app_animations.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/border_radius_extension.dart';
import '../../../core/extensions/edge_insets_extension.dart';
import '../../../core/extensions/spacing_extension.dart';
import '../../../core/extensions/typography_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_image.dart';
import '../controllers/news_controller.dart';
import '../models/news_item.dart';

class NewsCardWidget extends StatefulWidget {
  final NewsItem newsItem;
  final int currentIndex;
  final int totalCount;

  const NewsCardWidget({
    Key? key,
    required this.newsItem,
    required this.currentIndex,
    required this.totalCount,
  }) : super(key: key);

  @override
  State<NewsCardWidget> createState() => _NewsCardWidgetState();
}

class _NewsCardWidgetState extends State<NewsCardWidget> {
  VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return AppStrings.recently;
    final diff = DateTime.now().difference(date);
    if (diff.isNegative) return AppStrings.recently;
    if (diff.inMinutes < 60) {
      final unit = diff.inMinutes == 1 ? AppStrings.minuteAgo : AppStrings.minutesAgo;
      return '${diff.inMinutes} $unit';
    } else if (diff.inHours < 24) {
      final unit = diff.inHours == 1 ? AppStrings.hourAgo : AppStrings.hoursAgo;
      return '${diff.inHours} $unit';
    } else {
      final unit = diff.inDays == 1 ? AppStrings.dayAgo : AppStrings.daysAgo;
      return '${diff.inDays} $unit';
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoIfNeeded();
  }

  void _initVideoIfNeeded() {
    final vUrl = widget.newsItem.videoUrl;
    if (widget.newsItem.isVideo && vUrl != null && (vUrl.endsWith('.mp4') || vUrl.contains('.m3u8'))) {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(vUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
          }
        }).catchError((_) {});
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = context.read<NewsController>();
    final timeAgo = _formatTimeAgo(widget.newsItem.pubDate);
    final isVideoItem = widget.newsItem.isVideo;

    if (isVideoItem) {
      return _buildFullVideoLayout(context, size, controller, timeAgo);
    }

    return _buildStandardArticleLayout(context, size, controller, timeAgo);
  }

  // Standard article card
  Widget _buildStandardArticleLayout(
    BuildContext context,
    Size size,
    NewsController controller,
    String timeAgo,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.white;
    final cardPillBg = isDark ? AppColors.surfaceDark : AppColors.white;
    final textColor = isDark ? AppColors.white : AppColors.textPrimaryLight;
    final bodyTextColor = isDark ? AppColors.textBodyDark : AppColors.textBodyLight;
    final metaTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final bottomBannerBg = isDark ? AppColors.surfaceDark : AppColors.bannerBackgroundLight;
    final bottomBorderColor = isDark ? AppColors.borderDark : AppColors.dividerLight;

    final sourceName = widget.newsItem.source.isNotEmpty ? widget.newsItem.source : AppStrings.defaultInshortsSource;

    return Container(
      width: size.width,
      height: size.height,
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Image Stack (~40% height) with unified Source Pill & Action Buttons Row
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Main Article Image (Tap to view Full-Screen Image Modal)
              GestureDetector(
                onTap: () => _openFullScreenImageModal(context, widget.newsItem.imageUrl),
                child: AppImage(
                  imagePath: widget.newsItem.imageUrl,
                  height: size.height * 0.40,
                  width: size.width,
                  fit: BoxFit.cover,
                ),
              ),

              // Unified Positioned Row (Source Pill on Left + Save & Share Icons on Right)
              Positioned(
                bottom: -18,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Source Pill Container (Flexible & Ellipsis constrained so it never overflows)
                    Flexible(
                      child: Container(
                        padding: edge.v6.h10,
                        decoration: BoxDecoration(
                          color: cardPillBg,
                          borderRadius: radius.all20,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: edge.all4,
                              decoration: BoxDecoration(
                                color: AppColors.brandRed,
                                borderRadius: radius.all4,
                              ),
                              child: const Icon(Icons.grid_view_rounded, color: AppColors.white, size: 10),
                            ),
                            6.width,
                            Flexible(
                              child: Text(
                                sourceName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: poppins.get12.bold.textColor(textColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.width,

                    // Action Icons: Save (Bookmark) & Share Row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Save / Bookmark Button (Reactive Consumer for immediate state update)
                        Consumer<NewsController>(
                          builder: (context, newsController, child) {
                            final isSaved = newsController.isBookmarked(widget.newsItem);
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                newsController.toggleBookmark(widget.newsItem);
                                setState(() {});
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      !isSaved
                                          ? AppStrings.bookmarkAdded
                                          : AppStrings.bookmarkRemoved,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Container(
                                padding: edge.all6, // Extra outer gesture padding
                                child: Container(
                                  padding: edge.all8,
                                  decoration: BoxDecoration(
                                    color: cardPillBg,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withValues(alpha: 0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                                    color: isSaved
                                        ? AppColors.brandRed
                                        : (isDark ? AppColors.white : Colors.black87),
                                    size: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        4.width,

                        // Share Button (Expanded 48x48 Touch Target Area)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            try {
                              final textToShare = '${widget.newsItem.title}\n\n${widget.newsItem.link}';
                              await Share.share(
                                textToShare,
                                subject: widget.newsItem.title,
                              );
                            } catch (e) {
                              debugPrint('Share error: $e');
                            }
                          },
                          child: Container(
                            padding: edge.all6, // Extra outer gesture padding
                            child: Container(
                              padding: edge.all8,
                              decoration: BoxDecoration(
                                color: cardPillBg,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.share_outlined,
                                color: isDark ? AppColors.white : Colors.black87,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          26.height, // Gap for overlapping floating pills

          // 2. Main Headline & Story Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title / Headline
                  Text(
                    widget.newsItem.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: poppins.get18.bold.textColor(textColor),
                  ),
                  10.height,

                  // Scrollable Body Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        widget.newsItem.description,
                        style: poppins.get14.regular.textColor(bodyTextColor),
                      ),
                    ),
                  ),
                  8.height,

                  // Timestamp & Author Meta line
                  Text(
                    '$timeAgo | $sourceName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: poppins.get11.medium.textColor(metaTextColor),
                  ),
                  8.height,
                ],
              ),
            ),
          ),

          // Bottom Tap Banner to Open Article Link
          InkWell(
            onTap: () {
              controller.openArticleUrl(widget.newsItem.link);
            },
            child: Container(
              padding: edge.v10h10.copyWith(left: 16, right: 16),
              decoration: BoxDecoration(
                color: bottomBannerBg,
                border: Border(
                  top: BorderSide(color: bottomBorderColor, width: 0.8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: textColor,
                  ),
                  8.width,
                  Expanded(
                    child: Text(
                      AppStrings.tapToReadFull,
                      style: poppins.get12.semiBold.textColor(textColor),
                    ),
                  ),
                  Container(
                    padding: edge.v4h8,
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.08),
                      borderRadius: radius.all10,
                    ),
                    child: Text(
                      '${widget.currentIndex + 1}/${widget.totalCount}',
                      style: poppins.get11.bold.textColor(textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Full Screen Video Layout
  Widget _buildFullVideoLayout(
    BuildContext context,
    Size size,
    NewsController controller,
    String timeAgo,
  ) {
    final hasRealVideo = _videoPlayerController != null && _isVideoInitialized;

    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.black,
      child: Stack(
        children: [
          // Background Real Video Player OR Smooth Thumbnail Image
          Positioned.fill(
            child: hasRealVideo
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoPlayerController!.value.size.width,
                      height: _videoPlayerController!.value.size.height,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  )
                : (widget.newsItem.imageUrl != null && widget.newsItem.imageUrl!.isNotEmpty
                    ? SmoothFadeImage(
                        imageUrl: widget.newsItem.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.black87),
                      )
                    : Container(color: Colors.black87)),
          ),

          // Dark Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.3),
                    AppColors.trans,
                    AppColors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),

          // Center Play/Pause Button
          Center(
            child: GestureDetector(
              onTap: () {
                if (hasRealVideo) {
                  setState(() {
                    if (_videoPlayerController!.value.isPlaying) {
                      _videoPlayerController!.pause();
                      _isPlaying = false;
                    } else {
                      _videoPlayerController!.play();
                      _isPlaying = true;
                    }
                  });
                } else {
                  controller.openArticleUrl(widget.newsItem.videoUrl ?? widget.newsItem.link);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: AppColors.white,
                  size: 44,
                ),
              ),
            ),
          ),

          // Right Side Action Buttons (Share & Bookmark)
          Positioned(
            right: 12,
            bottom: 70,
            child: Column(
              children: [
                Consumer<NewsController>(
                  builder: (context, newsController, child) {
                    final isSaved = newsController.isBookmarked(widget.newsItem);
                    return IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? AppColors.brandRed : AppColors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        newsController.toggleBookmark(widget.newsItem);
                        setState(() {});
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              !isSaved
                                  ? AppStrings.bookmarkAdded
                                  : AppStrings.bookmarkRemoved,
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                ),
                Text(AppStrings.save, style: poppins.get10.bold.white),
                16.height,
                IconButton(
                  icon: const Icon(Icons.share, color: AppColors.white, size: 28),
                  onPressed: () {
                    Share.share('${widget.newsItem.title}\n\n${widget.newsItem.link}');
                  },
                ),
                Text(AppStrings.share, style: poppins.get10.bold.white),
              ],
            ),
          ),

          // Bottom Details Overlay
          Positioned(
            left: 16,
            right: 70,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.brandRed,
                      child: Text(
                        widget.newsItem.source.isEmpty
                            ? 'N'
                            : widget.newsItem.source.substring(0, 1).toUpperCase(),
                        style: poppins.get11.bold.white,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: Text(
                        widget.newsItem.source,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: poppins.get13.bold.white,
                      ),
                    ),
                  ],
                ),
                8.height,
                Text(
                  widget.newsItem.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: poppins.get14.bold.white,
                ),
                6.height,
                Text(
                  '$timeAgo | ${widget.newsItem.source}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppins.get11.medium.textColor(Colors.white70),
                ),
                10.height,
                if (hasRealVideo)
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _videoPlayerController!,
                    builder: (context, value, child) {
                      final duration = value.duration.inMilliseconds;
                      final position = value.position.inMilliseconds;
                      double progress = 0.0;
                      if (duration > 0) {
                        progress = (position / duration).clamp(0.0, 1.0);
                      }
                      return SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 3,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                          activeTrackColor: AppColors.cyanAccent,
                          inactiveTrackColor: Colors.white30,
                          thumbColor: AppColors.white,
                        ),
                        child: Slider(
                          value: progress,
                          onChanged: (val) {
                            final seekTarget = (val * duration).toInt();
                            _videoPlayerController!.seekTo(Duration(milliseconds: seekTarget));
                          },
                        ),
                      );
                    },
                  )
                else
                  SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                      activeTrackColor: AppColors.cyanAccent,
                      inactiveTrackColor: Colors.white30,
                      thumbColor: AppColors.white,
                    ),
                    child: Slider(
                      value: 0.35,
                      onChanged: (val) {},
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreenImageModal(
      BuildContext context,
      String? imageUrl,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: AppColors.trans,
      barrierColor: AppColors.trans,
      builder: (context) {
        final TransformationController transformationController = TransformationController();
        TapDownDetails? doubleTapDetails;

        return Dismissible(
          key: const Key('full_screen_image_dismiss'),
          direction: DismissDirection.down,
          onDismissed: (_) => Navigator.of(context).pop(),
          child: SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                // Blur the screen behind the modal
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 15,
                      sigmaY: 15,
                    ),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                ),

                // Full Screen Image
                Positioned.fill(
                  child: GestureDetector(
                    onDoubleTapDown: (details) {
                      doubleTapDetails = details;
                    },
                    onDoubleTap: () {
                      if (transformationController.value.isIdentity()) {
                        final position = doubleTapDetails?.localPosition ?? Offset.zero;
                        transformationController.value = Matrix4.identity()
                          ..translateByVector3(vector.Vector3(-position.dx * 1.5, -position.dy * 1.5, 0.0))
                          ..scaleByVector3(vector.Vector3(2.5, 2.5, 1.0));
                      } else {
                        transformationController.value = Matrix4.identity();
                      }
                    },
                    child: Center(
                      child: InteractiveViewer(
                        transformationController: transformationController,
                        clipBehavior: Clip.none,
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: 1.0,
                        maxScale: 5.0,
                        child: AppImage(
                          imagePath: imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),

                // Close Button
                Positioned(
                  top: 36,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: edge.all6,
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white38,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



}
