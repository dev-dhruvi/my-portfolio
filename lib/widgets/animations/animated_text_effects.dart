import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A premium animated text effect that continuously sweeps a luminous gradient
/// across the text, creating a subtle, high-end metallic or cyber shimmer.
class ShimmerGradientText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final List<Color>? colors;
  final Duration duration;
  final bool animate;

  const ShimmerGradientText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.colors,
    this.duration = const Duration(seconds: 4),
    this.animate = true,
  });

  @override
  State<ShimmerGradientText> createState() => _ShimmerGradientTextState();
}

class _ShimmerGradientTextState extends State<ShimmerGradientText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ShimmerGradientText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final defaultColors = [
      AppColors.violetPrimary,
      AppColors.cyanPrimary,
      const Color(0xFFA855F7), // Purple/Magenta accent
      AppColors.cyanPrimary,
      AppColors.violetPrimary,
    ];

    final colors = widget.colors ?? defaultColors;

    final textWidget = Text(
      widget.text,
      textAlign: widget.textAlign,
      style:
          (widget.style ??
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              .copyWith(color: Colors.white),
    );

    if (disableAnimations || !widget.animate) {
      return ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [colors.first, colors[colors.length ~/ 2]],
          ).createShader(bounds);
        },
        child: textWidget,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final double value = _controller.value;
            // Shift gradient stops dynamically to sweep across text
            return LinearGradient(
              begin: Alignment(-2.0 + (value * 3.0), -0.5),
              end: Alignment(0.0 + (value * 3.0), 0.5),
              colors: colors,
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: textWidget,
    );
  }
}

/// Staggers each word or token in a headline, sliding up and fading in
/// smoothly with cinematic ease-out physics.
class AnimatedHeadlineReveal extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Duration wordDelay;
  final Duration wordDuration;
  final Curve curve;

  const AnimatedHeadlineReveal({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.wordDelay = const Duration(milliseconds: 60),
    this.wordDuration = const Duration(milliseconds: 550),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedHeadlineReveal> createState() => _AnimatedHeadlineRevealState();
}

class _AnimatedHeadlineRevealState extends State<AnimatedHeadlineReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<String> _words;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');
    final totalDuration =
        widget.wordDuration + (widget.wordDelay * _words.length);

    _controller = AnimationController(vsync: this, duration: totalDuration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations) {
      return Text(
        widget.text,
        textAlign: widget.textAlign,
        style: widget.style,
      );
    }

    final totalMs = _controller.duration!.inMilliseconds;
    final wordDurationMs = widget.wordDuration.inMilliseconds;
    final wordDelayMs = widget.wordDelay.inMilliseconds;

    return Wrap(
      alignment: widget.textAlign == TextAlign.center
          ? WrapAlignment.center
          : WrapAlignment.start,
      spacing: 6.0,
      runSpacing: 4.0,
      children: List.generate(_words.length, (index) {
        final startMs = index * wordDelayMs;
        final endMs = (startMs + wordDurationMs).clamp(0, totalMs);

        final interval = Interval(
          startMs / totalMs,
          endMs / totalMs,
          curve: widget.curve,
        );

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _controller, curve: interval));

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.35),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: interval));

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(position: slideAnimation, child: child),
            );
          },
          child: Text(_words[index], style: widget.style),
        );
      }),
    );
  }
}
