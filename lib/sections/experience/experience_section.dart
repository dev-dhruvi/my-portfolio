import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/experience_calculator.dart';
import '../../models/experience.dart';
import '../../widgets/cards/glass_card.dart';

/// Vertical timeline displaying verified work experience with merged
/// duration calculation, responsive alternating desktop timeline, left-rail
/// mobile timeline, and an interactive CustomPainter-drawn vertical axis line.
class ExperienceSection extends StatefulWidget {
  final List<Experience> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  final ValueNotifier<double> _scrollProgressNotifier = ValueNotifier<double>(
    0.0,
  );
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition != position) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = position;
      _scrollPosition?.addListener(_onScroll);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _scrollProgressNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _scrollProgressNotifier.value = 1.0;
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      _scrollProgressNotifier.value = 1.0;
      return;
    }

    final globalPos = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (screenHeight <= 0) {
      _scrollProgressNotifier.value = 1.0;
      return;
    }

    final boxHeight = renderBox.size.height;
    final enterThreshold = screenHeight * 0.85;
    final totalScrollTravel = boxHeight + (screenHeight * 0.35);
    final distanceScrolled = enterThreshold - globalPos.dy;

    final progress = (distanceScrolled / math.max(1.0, totalScrollTravel))
        .clamp(0.0, 1.0);
    _scrollProgressNotifier.value = progress;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = !isMobile && !isTablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    // Calculate total cumulative experience across all ranges without double counting
    final ranges = widget.experiences
        .map((e) => {'start': e.startDate, 'end': e.endDate})
        .toList();
    final totalExperienceFormatted =
        ExperienceCalculator.calculateTotalExperience(ranges);

    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 24 : (isMobile ? 20 : 24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Section Tag & Header
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'CAREER PATH',
                style: TextStyle(
                  color: AppColors.cyanPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Work Experience & Roles',
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 24 : 32),
          ),
          const SizedBox(height: 6),

          // Total Experience Duration Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.violetPrimary.withOpacity(isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.violetPrimary.withOpacity(isDark ? 0.3 : 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: isDark ? AppColors.cyanPrimary : AppColors.cyanDark,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Total Cumulative Experience: $totalExperienceFormatted (Verified intervals)',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Responsive Vertical Timeline
          LayoutBuilder(
            builder: (context, constraints) {
              final isAlternating = constraints.maxWidth >= 860;

              return Stack(
                children: [
                  // Vertical Axis Line (Dynamic Scroll Fill via CustomPainter)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _TimelineAxisPainter(
                        progressNotifier: _scrollProgressNotifier,
                        isDesktop: isAlternating,
                        trackColor: isDark
                            ? AppColors.violetPrimary.withOpacity(0.18)
                            : Colors.grey.shade300,
                        activeColor1: AppColors.violetPrimary,
                        activeColor2: AppColors.cyanPrimary,
                      ),
                    ),
                  ),

                  // Timeline Milestone Items
                  Column(
                    children: [
                      for (int i = 0; i < widget.experiences.length; i++) ...[
                        if (i > 0) SizedBox(height: isAlternating ? 36 : 24),
                        if (isAlternating)
                          _buildDesktopRow(context, widget.experiences[i], i)
                        else
                          _buildMobileRow(context, widget.experiences[i], i),
                      ],
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(BuildContext context, Experience exp, int index) {
    final isCardLeft = index % 2 == 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Card or Date Badge)
        Expanded(
          child: isCardLeft
              ? _wrapCardAnimation(
                  context: context,
                  child: _ExperienceCard(experience: exp, isMobile: false),
                  index: index,
                  fromLeft: true,
                )
              : _wrapCardAnimation(
                  context: context,
                  child: _TimelineDateBadge(
                    experience: exp,
                    index: index,
                    isLeft: true,
                  ),
                  index: index,
                  fromLeft: true,
                ),
        ),

        // Center Axis Milestone Node
        SizedBox(
          width: 64,
          child: Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Center(
              child: _wrapNodeAnimation(
                context: context,
                child: _TimelineNode(
                  index: index,
                  isDesktop: true,
                  progressNotifier: _scrollProgressNotifier,
                  totalItems: widget.experiences.length,
                ),
                index: index,
              ),
            ),
          ),
        ),

        // Right Column (Date Badge or Card)
        Expanded(
          child: isCardLeft
              ? _wrapCardAnimation(
                  context: context,
                  child: _TimelineDateBadge(
                    experience: exp,
                    index: index,
                    isLeft: false,
                  ),
                  index: index,
                  fromLeft: false,
                )
              : _wrapCardAnimation(
                  context: context,
                  child: _ExperienceCard(experience: exp, isMobile: false),
                  index: index,
                  fromLeft: false,
                ),
        ),
      ],
    );
  }

  Widget _buildMobileRow(BuildContext context, Experience exp, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Center(
              child: _wrapNodeAnimation(
                context: context,
                child: _TimelineNode(
                  index: index,
                  isDesktop: false,
                  progressNotifier: _scrollProgressNotifier,
                  totalItems: widget.experiences.length,
                ),
                index: index,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _wrapCardAnimation(
            context: context,
            child: _ExperienceCard(experience: exp, isMobile: true),
            index: index,
            fromLeft: false,
          ),
        ),
      ],
    );
  }

  Widget _wrapCardAnimation({
    required BuildContext context,
    required Widget child,
    required int index,
    required bool fromLeft,
  }) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return child;
    }
    return child
        .animate(delay: Duration(milliseconds: 90 * index))
        .fadeIn(
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeOutCubic,
        )
        .slideX(
          begin: fromLeft ? -0.12 : 0.12,
          end: 0,
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeOutCubic,
        );
  }

  Widget _wrapNodeAnimation({
    required BuildContext context,
    required Widget child,
    required int index,
  }) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return child;
    }
    return child
        .animate(delay: Duration(milliseconds: 90 * index))
        .fadeIn(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.4, 0.4),
          end: const Offset(1.0, 1.0),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutBack,
        );
  }
}

/// CustomPainter that renders the vertical timeline spine track and dynamic
/// glowing gradient fill linked to the user's scroll progress.
class _TimelineAxisPainter extends CustomPainter {
  final ValueNotifier<double> progressNotifier;
  final bool isDesktop;
  final Color trackColor;
  final Color activeColor1;
  final Color activeColor2;

  _TimelineAxisPainter({
    required this.progressNotifier,
    required this.isDesktop,
    required this.trackColor,
    required this.activeColor1,
    required this.activeColor2,
  }) : super(repaint: progressNotifier);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height <= 0) return;

    final double x = isDesktop ? size.width / 2 : 20.0;
    const double startY = 16.0;
    final double endY = math.max(startY, size.height - 24.0);
    final double totalHeight = endY - startY;

    if (totalHeight <= 0) return;

    // 1. Static guide track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(x, startY), Offset(x, endY), trackPaint);

    final progress = progressNotifier.value.clamp(0.0, 1.0);
    if (progress <= 0.0) return;

    final currentY = startY + (totalHeight * progress);

    // 2. Soft ambient glow behind active line
    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          activeColor1.withOpacity(0.35),
          activeColor2.withOpacity(0.45),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(x - 6, startY, x + 6, currentY))
      ..strokeWidth = 8.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(x, startY), Offset(x, currentY), glowPaint);

    // 3. Sharp active gradient line
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [activeColor1, activeColor2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(x - 2, startY, x + 2, currentY))
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(x, startY), Offset(x, currentY), fillPaint);

    // 4. Glowing tracer pulse dot at front of the line
    final headGlow = Paint()
      ..color = activeColor2.withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(x, currentY), 5.5, headGlow);

    final headCore = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, currentY), 3.0, headCore);
  }

  @override
  bool shouldRepaint(covariant _TimelineAxisPainter oldDelegate) {
    return oldDelegate.progressNotifier != progressNotifier ||
        oldDelegate.isDesktop != isDesktop ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.activeColor1 != activeColor1 ||
        oldDelegate.activeColor2 != activeColor2;
  }
}

/// Interactive milestone circular node along the timeline axis with dynamic
/// illumination when reached by the scroll-linked progress line.
class _TimelineNode extends StatelessWidget {
  final int index;
  final bool isDesktop;
  final ValueNotifier<double> progressNotifier;
  final int totalItems;

  const _TimelineNode({
    required this.index,
    required this.isDesktop,
    required this.progressNotifier,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final threshold = totalItems <= 1
        ? 0.0
        : (index / (totalItems - 1)).clamp(0.0, 1.0);

    return ValueListenableBuilder<double>(
      valueListenable: progressNotifier,
      builder: (context, progress, _) {
        final isActive =
            progress >= threshold ||
            (MediaQuery.maybeDisableAnimationsOf(context) ?? false);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkBackground : Colors.white,
            border: Border.all(
              color: isActive
                  ? AppColors.cyanPrimary
                  : AppColors.violetPrimary.withOpacity(isDark ? 0.4 : 0.3),
              width: isActive ? 2.5 : 2.0,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.cyanPrimary.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: AppColors.violetPrimary.withOpacity(0.3),
                      blurRadius: 6,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                      blurRadius: 4,
                    ),
                  ],
          ),
          child: Center(
            child: Icon(
              _getNodeIcon(index),
              size: 17,
              color: isActive
                  ? (isDark ? AppColors.cyanLight : AppColors.cyanDark)
                  : (isDark
                        ? AppColors.textMutedDark
                        : AppColors.textSecondaryLight),
            ),
          ),
        );
      },
    );
  }

  IconData _getNodeIcon(int idx) {
    switch (idx) {
      case 0:
        return Icons.workspace_premium_rounded;
      case 1:
        return Icons.flutter_dash_rounded;
      case 2:
        return Icons.phone_android_rounded;
      case 3:
        return Icons.school_rounded;
      default:
        return Icons.work_rounded;
    }
  }
}

/// Stylish milestone and date indicator displayed on the opposite side of the
/// experience card in alternating desktop layout.
class _TimelineDateBadge extends StatelessWidget {
  final Experience experience;
  final int index;
  final bool isLeft;

  const _TimelineDateBadge({
    required this.experience,
    required this.index,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Padding(
      padding: EdgeInsets.only(
        top: 12.0,
        left: isLeft ? 16.0 : 20.0,
        right: isLeft ? 20.0 : 16.0,
      ),
      child: Column(
        crossAxisAlignment: isLeft
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Date Interval Text
          Text(
            '${experience.startDate} – ${experience.endDate}',
            textAlign: isLeft ? TextAlign.end : TextAlign.start,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),

          // Location badge
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: secondaryTextColor,
              ),
              const SizedBox(width: 4),
              Text(
                experience.location,
                style: TextStyle(fontSize: 12, color: secondaryTextColor),
              ),
            ],
          ),
          if (experience.calculatedDuration.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              experience.calculatedDuration,
              textAlign: isLeft ? TextAlign.end : TextAlign.start,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.cyanPrimary : AppColors.violetPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Experience card with interactive hover lift, expandable bullet points,
/// and verified tech stack tags.
class _ExperienceCard extends StatefulWidget {
  final Experience experience;
  final bool isMobile;

  const _ExperienceCard({required this.experience, this.isMobile = false});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final responsibilities = widget.experience.responsibilities;
    const maxInitialItems = 3;
    final hasManyResponsibilities = responsibilities.length > maxInitialItems;
    final displayedResponsibilities = (_isExpanded || !hasManyResponsibilities)
        ? responsibilities
        : responsibilities.take(maxInitialItems).toList();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -3.0, 0.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.violetPrimary.withOpacity(
                      isDark ? 0.25 : 0.15,
                    ),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: GlassCard(
          padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.experience.role,
                          style: AppTypography.getTitleLarge(textColor)
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: widget.isMobile ? 16 : 17.5,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              widget.experience.company,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.violetLight
                                    : AppColors.violetDark,
                                fontWeight: FontWeight.w600,
                                fontSize: widget.isMobile ? 13.5 : 14.5,
                              ),
                            ),
                            Text(
                              '•',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            Text(
                              widget.experience.locationType ?? "On-Site",
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: widget.isMobile ? 12 : 12.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (widget.isMobile) ...[
                    const SizedBox(width: 8),
                    _buildMobileDatePill(),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Responsibilities Bullet List
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: displayedResponsibilities.map((resp) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0, right: 6.0),
                          child: Icon(
                            Icons.arrow_right_rounded,
                            size: 16,
                            color: AppColors.violetPrimary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            resp,
                            style:
                                AppTypography.getBodyMedium(secondaryTextColor)
                                    .copyWith(
                                      fontSize: widget.isMobile ? 12 : 12.5,
                                      height: 1.4,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // Show more / Show less toggle
              if (hasManyResponsibilities) ...[
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isExpanded
                              ? 'Show fewer'
                              : 'Show all ${responsibilities.length} items',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.cyanPrimary
                                : AppColors.violetPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 14,
                          color: isDark
                              ? AppColors.cyanPrimary
                              : AppColors.violetPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],

              // Tech Stack Chips
              if (widget.experience.technologies.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.experience.technologies.map((tech) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardHover
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkCardBorder
                              : AppColors.lightCardBorder,
                        ),
                      ),
                      child: Text(
                        tech,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDatePill() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.cyanPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cyanPrimary.withOpacity(0.25)),
          ),
          child: Text(
            widget.experience.endDate,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.cyanPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
