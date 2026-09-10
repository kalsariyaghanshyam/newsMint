import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.easeOutBack;
}

class FadeInWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double slideOffset;

  const FadeInWidget({
    Key? key,
    required this.child,
    this.duration = AppAnimations.medium,
    this.curve = AppAnimations.defaultCurve,
    this.slideOffset = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * slideOffset),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class SmoothFadeImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const SmoothFadeImage({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0.0 : 1.0,
          duration: AppAnimations.medium,
          curve: AppAnimations.defaultCurve,
          child: child,
        );
      },
      errorBuilder: errorBuilder,
    );
  }
}

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlidePageRoute({required this.page, RouteSettings? settings})
      : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.05, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: AppAnimations.defaultCurve,
              ),
            );

            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: AppAnimations.defaultCurve,
            );

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: AppAnimations.medium,
        );
}
