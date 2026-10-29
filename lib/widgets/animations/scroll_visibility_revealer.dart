import 'package:flutter/material.dart';

/// Performance-focused widget that triggers entrance animations (fade, slide, scale)
/// only when the child scrolls into the visible viewport.
///
/// Ensures below-the-fold sections don't waste their animations before the user reaches them.
class ScrollVisibilityRevealer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideDistance;
  final double initialScale;
  final double viewportThreshold;
  final bool animateOnce;
  final Curve curve;

  const ScrollVisibilityRevealer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 550),
    this.delay = Duration.zero,
    this.slideDistance = 24.0,
    this.initialScale = 1.0,
    this.viewportThreshold = 0.88,
    this.animateOnce = true,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ScrollVisibilityRevealer> createState() =>
      _ScrollVisibilityRevealerState();
}

class _ScrollVisibilityRevealerState extends State<ScrollVisibilityRevealer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  ScrollPosition? _scrollPosition;
  bool _isVisible = false;
  bool _hasAnimated = false;
  double _lastCheckedOffset = -100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _slideAnimation = Tween<double>(
      begin: widget.slideDistance,
      end: 0.0,
    ).animate(curved);
    _scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: 1.0,
    ).animate(curved);

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
    if ((currentOffset - _lastCheckedOffset).abs() < 24.0) return;
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
        if (widget.delay == Duration.zero) {
          _controller.forward();
        } else {
          Future.delayed(widget.delay, () {
            if (mounted && _isVisible) {
              _controller.forward();
            }
          });
        }
      }
    } else if (!widget.animateOnce && _isVisible) {
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

    final hasTransform =
        widget.slideDistance > 0.0 || widget.initialScale != 1.0;

    return RepaintBoundary(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: hasTransform
            ? AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  Widget result = child!;
                  if (widget.slideDistance > 0.0) {
                    result = Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: result,
                    );
                  }
                  if (widget.initialScale != 1.0) {
                    result = Transform.scale(
                      scale: _scaleAnimation.value,
                      child: result,
                    );
                  }
                  return result;
                },
                child: widget.child,
              )
            : widget.child,
      ),
    );
  }
}
