import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A 3D-styled interactive card widget that responds to mouse hover with
/// realistic perspective tilt, dynamic specular glare, and smooth spring-back physics.
/// On touch devices, provides smooth tactile scale feedback.
///
/// Designed to be intrinsically measurable without [LayoutBuilder], allowing it
/// to safely be used inside [IntrinsicHeight], [Row], [Column], or [Flex] widgets.
class Interactive3DCard extends StatefulWidget {
  final Widget child;

  /// Maximum tilt angle in radians (e.g., 0.12 rad is ~7 degrees).
  final double maxTiltAngle;

  /// Perspective factor for Matrix4 setEntry(3, 2, depth).
  final double perspective;

  /// Subtle zoom/scale applied when hovered.
  final double hoverScale;

  /// Whether to render a moving specular glare reflection across the card surface.
  final bool enableGlare;

  /// The specular glare highlight color.
  final Color? glareColor;

  /// Border radius applied to clip the specular glare to the card's shape.
  final BorderRadius? borderRadius;

  /// Optional click callback.
  final VoidCallback? onTap;

  /// Shadow elevation multiplier on hover.
  final double hoverElevation;

  const Interactive3DCard({
    super.key,
    required this.child,
    this.maxTiltAngle = 0.12,
    this.perspective = 0.0012,
    this.hoverScale = 1.025,
    this.enableGlare = true,
    this.glareColor,
    this.borderRadius,
    this.onTap,
    this.hoverElevation = 1.0,
  });

  @override
  State<Interactive3DCard> createState() => _Interactive3DCardState();
}

class _Interactive3DCardState extends State<Interactive3DCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _resetController;
  late Animation<double> _tiltXAnimation;
  late Animation<double> _tiltYAnimation;
  late Animation<double> _scaleAnimation;

  double _tiltX = 0.0;
  double _tiltY = 0.0;
  double _scale = 1.0;
  Offset _pointerPosition = Offset.zero;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _resetController.addListener(() {
      setState(() {
        _tiltX = _tiltXAnimation.value;
        _tiltY = _tiltYAnimation.value;
        _scale = _scaleAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onHover(PointerHoverEvent event) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final size = renderBox.size;
    if (size.width == 0 || size.height == 0) return;

    _resetController.stop();

    final local = event.localPosition;
    _pointerPosition = local;

    // Normalize coordinates to -1.0 .. 1.0 from center
    final normalizedX = ((local.dx / size.width) - 0.5) * 2.0;
    final normalizedY = ((local.dy / size.height) - 0.5) * 2.0;

    setState(() {
      _isHovered = true;
      // Tilting around X axis responds to vertical movement (Y)
      _tiltX = (-normalizedY * widget.maxTiltAngle).clamp(
        -widget.maxTiltAngle,
        widget.maxTiltAngle,
      );
      // Tilting around Y axis responds to horizontal movement (X)
      _tiltY = (normalizedX * widget.maxTiltAngle).clamp(
        -widget.maxTiltAngle,
        widget.maxTiltAngle,
      );
      _scale = widget.hoverScale;
    });
  }

  void _onExit(PointerExitEvent event) {
    _animateReturnToRest();
  }

  void _animateReturnToRest() {
    if (!mounted) return;

    final curve = CurvedAnimation(
      parent: _resetController,
      curve: Curves.easeOutBack,
    );

    _tiltXAnimation = Tween<double>(begin: _tiltX, end: 0.0).animate(curve);
    _tiltYAnimation = Tween<double>(begin: _tiltY, end: 0.0).animate(curve);
    _scaleAnimation = Tween<double>(begin: _scale, end: 1.0).animate(curve);

    setState(() {
      _isHovered = false;
      _isPressed = false;
    });

    _resetController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations) {
      return GestureDetector(onTap: widget.onTap, child: widget.child);
    }

    final transform = Matrix4.identity()
      ..setEntry(3, 2, widget.perspective)
      ..rotateX(_tiltX)
      ..rotateY(_tiltY)
      ..scale(_isPressed ? 0.98 : _scale);

    final glareColor =
        widget.glareColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.12)
            : Colors.white.withOpacity(0.24));

    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    final content = Transform(
      transform: transform,
      alignment: FractionalOffset.center,
      child: RepaintBoundary(
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            widget.child,

            // Dynamic specular glare sheen
            if (widget.enableGlare && _isHovered)
              Positioned.fill(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: radius,
                    child: CustomPaint(
                      painter: _SpecularGlarePainter(
                        glarePosition: _pointerPosition,
                        glareColor: glareColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onHover: _onHover,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => _animateReturnToRest(),
        onTapCancel: () => _animateReturnToRest(),
        child: content,
      ),
    );
  }
}

class _SpecularGlarePainter extends CustomPainter {
  final Offset glarePosition;
  final Color glareColor;

  _SpecularGlarePainter({
    required this.glarePosition,
    required this.glareColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          ((glarePosition.dx / size.width) - 0.5) * 2.0,
          ((glarePosition.dy / size.height) - 0.5) * 2.0,
        ),
        radius: 0.8,
        colors: [glareColor, glareColor.withOpacity(0.0)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_SpecularGlarePainter oldDelegate) {
    return oldDelegate.glarePosition != glarePosition ||
        oldDelegate.glareColor != glareColor;
  }
}
