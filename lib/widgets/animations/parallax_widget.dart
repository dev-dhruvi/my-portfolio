import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';

/// A lightweight, performance-optimized parallax widget that smoothly offsets its
/// child vertically based on the current scroll position relative to the viewport.
///
/// Gives visual assets, 3D character illustrations, floating badges, and cards
/// a subtle sense of physical depth without motion sickness.
class ParallaxWidget extends StatefulWidget {
  final Widget child;

  /// Speed factor:
  /// - Positive (e.g. 0.08): moves slightly slower than surrounding content (floating behind)
  /// - Negative (e.g. -0.06): moves slightly faster than surrounding content (floating ahead)
  final double speed;

  /// Maximum vertical translation in pixels to keep layout tight and prevent clipping.
  final double maxOffset;

  /// Whether parallax should be active on mobile screens (< 768px). Defaults to false
  /// to conserve battery and keep mobile scrolling lightweight and crisp.
  final bool enabledOnMobile;

  const ParallaxWidget({
    super.key,
    required this.child,
    this.speed = 0.08,
    this.maxOffset = 30.0,
    this.enabledOnMobile = false,
  });

  @override
  State<ParallaxWidget> createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget> {
  final ValueNotifier<double> _offsetNotifier = ValueNotifier<double>(0.0);
  ScrollPosition? _scrollPosition;
  double _lastCheckedOffset = -100.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPosition = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition != newPosition) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _offsetNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final isMobile = AppBreakpoints.isMobile(context);

    if (disableAnimations || (isMobile && !widget.enabledOnMobile)) {
      if (_offsetNotifier.value != 0.0) {
        _offsetNotifier.value = 0.0;
      }
      return;
    }

    final currentOffset = _scrollPosition?.pixels ?? 0.0;
    if ((currentOffset - _lastCheckedOffset).abs() < 8.0) return;
    _lastCheckedOffset = currentOffset;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final screenHeight = MediaQuery.sizeOf(context).height;
    if (screenHeight <= 0) return;

    final globalPos = renderBox.localToGlobal(Offset.zero);
    final elementCenter = globalPos.dy + (renderBox.size.height / 2);
    final screenCenter = screenHeight / 2;

    // Relative delta from the viewport center
    final deltaFromCenter = elementCenter - screenCenter;
    final targetOffset = (deltaFromCenter * widget.speed).clamp(
      -widget.maxOffset,
      widget.maxOffset,
    );

    // Only update if difference exceeds sub-pixel threshold to minimize repaints
    if ((_offsetNotifier.value - targetOffset).abs() > 0.4) {
      _offsetNotifier.value = targetOffset;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final isMobile = AppBreakpoints.isMobile(context);

    if (disableAnimations || (isMobile && !widget.enabledOnMobile)) {
      return widget.child;
    }

    return RepaintBoundary(
      child: ValueListenableBuilder<double>(
        valueListenable: _offsetNotifier,
        builder: (context, offset, child) {
          if (offset == 0.0) return child!;
          return Transform.translate(offset: Offset(0, offset), child: child);
        },
        child: widget.child,
      ),
    );
  }
}
