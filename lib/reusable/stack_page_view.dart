library stacked_page_view;

import 'dart:math';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// A Calculator.
class StackPageView extends StatefulWidget {
  const StackPageView({
    Key? key,
    required this.index,
    required this.controller,
    required this.child,
    this.animationAxis = Axis.vertical,
    this.backgroundColor = AppColors.black,
  }) : super(key: key);
  final int index;
  final PageController controller;
  final Widget child;
  final Axis animationAxis;
  final Color backgroundColor;
  @override
  State<StackPageView> createState() => StackPageViewState();
}

class StackPageViewState extends State<StackPageView> {
  int currentPosition = 0;
  double pagePosition = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updatePosition();
        widget.controller.addListener(_listener);
      }
    });
  }

  void _listener() {
    if (mounted && widget.controller.hasClients) {
      _updatePosition();
    }
  }

  void _updatePosition() {
    if (widget.controller.hasClients && widget.controller.page != null) {
      final double p = widget.controller.page!;
      final int c = p.floor();
      if (p != pagePosition || c != currentPosition) {
        setState(() {
          pagePosition = p;
          currentPosition = c;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 15.0;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double delta = pagePosition - widget.index;
          double start = widget.animationAxis == Axis.horizontal
              ? (size.width * 0.105) * delta.abs() * 10
              : (size.height * 0.105) * delta.abs() * 10;
          double sides = padding * max(-delta, 0.0);
          double opac = (sides / 0.5) * 0.1;
          double anotheropac = 0.0;
          if (num.parse(opac.toStringAsFixed(2)) <= 1.0) {
            anotheropac = num.parse(opac.toStringAsFixed(3)) * 0.5;
          } else if (num.parse(opac.toStringAsFixed(2)) >= 1.0) {
            anotheropac = 0.5;
          } else {
            anotheropac = num.parse(opac.toStringAsFixed(3)) * 0.07;
          }
          return Container(
            decoration: BoxDecoration( borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: currentPosition == widget.index
                  ? const EdgeInsets.all(0)
                  : EdgeInsets.only(left: sides, right: sides, bottom: sides),
              child: ColorFiltered(
                colorFilter: currentPosition != widget.index
                    ? ColorFilter.mode(
                    widget.backgroundColor.withValues(alpha: anotheropac),
                    BlendMode.darken)
                    : ColorFilter.mode(widget.backgroundColor.withValues(alpha: 0.01),
                    BlendMode.darken),
                child: ClipRRect(
                  child: Transform.translate(
                    offset: currentPosition != widget.index
                        ? (widget.animationAxis == Axis.horizontal
                        ? Offset(start, 0)
                        : Offset(0, -start))
                        : const Offset(0, 0),
                    child: ClipRRect(
                      borderRadius: currentPosition != widget.index
                          ? const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))
                          : const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0)),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Scaffold(body: widget.child),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}