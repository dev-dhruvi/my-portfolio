import 'package:flutter/material.dart';

enum RevealType { slideFade, clippedMask, scaleFade }

/// A premium scroll-triggered entrance and reveal animation widget.
///
/// Supports:
/// - Clipped mask reveals for typography and headings (inspired by eezyinn.de).
/// - Slide-and-fade entrances with configurable offset and curves.
/// - Staggered delays using [staggerIndex] and [staggerDelay].
/// - Bidirectional scrolling (reversing when scrolled out of view if [animateOnce] is false).
/// - Full accessibility compliance (instant render when [disableAnimations] is true).
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final int staggerIndex;
  final Duration staggerDelay;
  final double slideDistance;
  final double initialScale;
  final double viewportThreshold;
  final bool animateOnce;
  final Curve curve;
  final RevealType revealType;

  const ScrollReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 550),
    this.delay = Duration.zero,
    this.staggerIndex = 0,
    this.staggerDelay = const Duration(milliseconds: 70),
    this.slideDistance = 24.0,
    this.initialScale = 1.0,
    this.viewportThreshold = 0.88,
    this.animateOnce = true,
    this.curve = Curves.easeOutCubic,
    this.revealType = RevealType.slideFade,
  });

  /// Factory constructor for high-end clipped text reveals
  const ScrollReveal.clippedText({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.staggerIndex = 0,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.slideDistance = 32.0,
    this.viewportThreshold = 0.88,
    this.animateOnce = true,
    this.curve = Curves.easeOutCubic,
  }) : initialScale = 1.0,
       revealType = RevealType.clippedMask;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  ScrollPosition? _scrollPosition;
  bool _isVisible = false;
  bool _hasAnimated = false;
  double _lastCheckedOffset = -100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachScrollListener();
  }

  void _attachScrollListener() {
    if (widget.animateOnce && _hasAnimated) return;
    final scrollable = Scrollable.maybeOf(context);
    final newPosition = scrollable?.position;
    if (_scrollPosition != newPosition) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.animateOnce && _hasAnimated) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = null;
      return;
    }
    final currentOffset = _scrollPosition?.pixels ?? 0.0;
    if ((currentOffset - _lastCheckedOffset).abs() < 20.0) return;
    _lastCheckedOffset = currentOffset;
    _checkVisibility();
  }

  void _checkVisibility() {
    if (!mounted) return;
    if (widget.animateOnce && _hasAnimated) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = null;
      return;
    }

    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      if (!_isVisible) {
        _isVisible = true;
        _hasAnimated = true;
        _controller.value = 1.0;
        _scrollPosition?.removeListener(_onScroll);
        _scrollPosition = null;
      }
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final viewHeight = MediaQuery.sizeOf(context).height;
    final widgetPos = renderBox.localToGlobal(Offset.zero);

    // Calculate if element has entered threshold of visible viewport
    final topVisible = widgetPos.dy < (viewHeight * widget.viewportThreshold);
    final bottomVisible = (widgetPos.dy + renderBox.size.height) > 0;

    if (topVisible && bottomVisible) {
      if (!_isVisible) {
        _isVisible = true;
        _hasAnimated = true;
        if (widget.animateOnce) {
          _scrollPosition?.removeListener(_onScroll);
          _scrollPosition = null;
        }
        final totalDelay =
            widget.delay + (widget.staggerDelay * widget.staggerIndex);
        if (totalDelay == Duration.zero) {
          _controller.forward();
        } else {
          Future.delayed(totalDelay, () {
            if (mounted && _isVisible) {
              _controller.forward();
            }
          });
        }
      }
    } else if (!widget.animateOnce && _isVisible) {
      // Element has scrolled fully out of viewport: smoothly reset or reverse
      _isVisible = false;
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return widget.child;
    }

    if (widget.animateOnce && _hasAnimated && _controller.isCompleted) {
      return widget.child;
    }

    if (widget.revealType == RevealType.clippedMask) {
      return ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final t = _animation.value;
            final dy = (1.0 - t) * widget.slideDistance;
            return Transform.translate(
              offset: Offset(0, dy),
              child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
            );
          },
          child: widget.child,
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final t = _animation.value;
          Widget result = child!;

          if (widget.slideDistance > 0.0) {
            result = Transform.translate(
              offset: Offset(0, (1.0 - t) * widget.slideDistance),
              child: result,
            );
          }

          if (widget.initialScale != 1.0) {
            final currentScale =
                widget.initialScale + (1.0 - widget.initialScale) * t;
            result = Transform.scale(scale: currentScale, child: result);
          }

          return Opacity(opacity: t.clamp(0.0, 1.0), child: result);
        },
        child: widget.child,
      ),
    );
  }
}
