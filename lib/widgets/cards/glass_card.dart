import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../animations/interactive_3d_card.dart';

/// Reusable glassmorphic card with subtle gradient, thin border,
/// optional 3D tilt with specular sheen, and smooth hover elevation effects.
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? customBackgroundColor;
  final Color? customBorderColor;
  final bool enableHoverEffect;
  final bool enable3D;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.margin,
    this.borderRadius = 16,
    this.onTap,
    this.customBackgroundColor,
    this.customBorderColor,
    this.enableHoverEffect = true,
    this.enable3D = false,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg = isDark
        ? (_isHovered ? AppColors.darkCardHover : AppColors.darkCard)
        : (_isHovered ? AppColors.lightCardHover : AppColors.lightCard);

    final defaultBorder = isDark
        ? (_isHovered
              ? AppColors.darkCardBorderHover
              : AppColors.darkCardBorder)
        : (_isHovered
              ? AppColors.violetPrimary.withOpacity(0.4)
              : AppColors.lightCardBorder);

    final cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.customBackgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.customBorderColor ?? defaultBorder,
          width: _isHovered ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (isDark && _isHovered)
            BoxShadow(
              color: AppColors.violetPrimary.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          else if (!isDark && _isHovered)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: widget.child,
    );

    if (widget.enable3D) {
      return Interactive3DCard(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: widget.onTap,
        child: cardContent,
      );
    }

    if (widget.onTap != null || widget.enableHoverEffect) {
      return MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(onTap: widget.onTap, child: cardContent),
      );
    }

    return cardContent;
  }
}
