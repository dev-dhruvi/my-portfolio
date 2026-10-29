import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/education.dart';
import '../../widgets/animations/scroll_reveal.dart';
import '../../widgets/cards/glass_card.dart';

/// Education section presenting verified degrees, universities, honors,
/// and academic foundation accompanied by the 3D graduate character illustration,
/// enhanced with continuous floating animations and hover micro-interactions.
class EducationSection extends StatelessWidget {
  final List<Education> education;

  const EducationSection({super.key, required this.education});

  Widget _wrapFloating(
    Widget child, {
    required double begin,
    required double end,
    required Duration duration,
    required bool disableAnimations,
  }) {
    if (disableAnimations) return child;
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: begin,
          end: end,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = !isMobile && !isTablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
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
          // Section Tag & Header with clipped text reveal
          ScrollReveal.clippedText(
            staggerIndex: 0,
            child: Row(
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
                  'ACADEMIC FOUNDATION',
                  style: TextStyle(
                    color: AppColors.cyanPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ScrollReveal.clippedText(
            staggerIndex: 1,
            child: Text(
              'Education & Qualifications',
              style: AppTypography.getDisplayMedium(textColor)
                  .copyWith(fontSize: isMobile ? 26 : 32),
            ),
          ),
          const SizedBox(height: 24),

          // Responsive Education Layout Strategy:
          // Desktop (> 1050dp): 3-column row (MCA Card - Graduate Stage - BCA Card)
          // Tablet (650-1050dp): 2-tier layout (Stage top, degree cards side-by-side row below)
          // Mobile (< 650dp): Adaptive single-column stack
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktopLayout = constraints.maxWidth >= 1050;
              final isTabletLayout =
                  constraints.maxWidth >= 650 && constraints.maxWidth < 1050;

              if (isDesktopLayout) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (education.isNotEmpty)
                          Expanded(
                            flex: 7,
                            child: _wrapFloating(
                              _EducationCard(education: education[0]),
                              begin: 8,
                              end: -8,
                              duration: const Duration(milliseconds: 2800),
                              disableAnimations: disableAnimations,
                            ),
                          ),
                        const SizedBox(width: 22),
                        Expanded(
                          flex: 6,
                          child: _wrapFloating(
                            const _EducationCharacterStage(isMobile: false),
                            begin: -10,
                            end: 10,
                            duration: const Duration(milliseconds: 2400),
                            disableAnimations: disableAnimations,
                          ),
                        ),
                        const SizedBox(width: 22),
                        if (education.length > 1)
                          Expanded(
                            flex: 7,
                            child: _wrapFloating(
                              _EducationCard(education: education[1]),
                              begin: -8,
                              end: 8,
                              duration: const Duration(milliseconds: 3100),
                              disableAnimations: disableAnimations,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: _wrapFloating(
                        const _EducationAwardBadge(),
                        begin: -5,
                        end: 5,
                        duration: const Duration(milliseconds: 2600),
                        disableAnimations: disableAnimations,
                      ),
                    ),
                  ],
                );
              } else if (isTabletLayout) {
                return Column(
                  children: [
                    _wrapFloating(
                      const _EducationCharacterStage(isMobile: true),
                      begin: -8,
                      end: 8,
                      duration: const Duration(milliseconds: 2400),
                      disableAnimations: disableAnimations,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: _wrapFloating(
                        const _EducationAwardBadge(),
                        begin: -5,
                        end: 5,
                        duration: const Duration(milliseconds: 2600),
                        disableAnimations: disableAnimations,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (education.isNotEmpty)
                          Expanded(
                            child: _wrapFloating(
                              _EducationCard(education: education[0]),
                              begin: 6,
                              end: -6,
                              duration: const Duration(milliseconds: 2800),
                              disableAnimations: disableAnimations,
                            ),
                          ),
                        if (education.length > 1) ...[
                          const SizedBox(width: 18),
                          Expanded(
                            child: _wrapFloating(
                              _EducationCard(education: education[1]),
                              begin: -6,
                              end: 6,
                              duration: const Duration(milliseconds: 3100),
                              disableAnimations: disableAnimations,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _wrapFloating(
                      const _EducationCharacterStage(isMobile: true),
                      begin: -8,
                      end: 8,
                      duration: const Duration(milliseconds: 2400),
                      disableAnimations: disableAnimations,
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: _wrapFloating(
                        const _EducationAwardBadge(),
                        begin: -5,
                        end: 5,
                        duration: const Duration(milliseconds: 2600),
                        disableAnimations: disableAnimations,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...education.asMap().entries.map((entry) {
                      final index = entry.key;
                      final edu = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _wrapFloating(
                          _EducationCard(education: edu),
                          begin: index == 0 ? 6 : -6,
                          end: index == 0 ? -6 : 6,
                          duration: Duration(
                            milliseconds: 2700 + (index * 400),
                          ),
                          disableAnimations: disableAnimations,
                        ),
                      );
                    }),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _EducationCharacterStage extends StatelessWidget {
  final bool isMobile;

  const _EducationCharacterStage({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? 260 : 300,
            maxHeight: isMobile ? 260 : 300,
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Ambient Aura Glow behind character
              Container(
                width: isMobile ? 200 : 240,
                height: isMobile ? 200 : 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyanPrimary.withOpacity(isDark ? 0.32 : 0.18),
                      AppColors.violetPrimary.withOpacity(isDark ? 0.22 : 0.12),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),

              // Dashed rotating halo ring
              if (!disableAnimations)
                Positioned.fill(
                  child: Center(
                    child:
                        Container(
                              width: isMobile ? 215 : 255,
                              height: isMobile ? 215 : 255,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.cyanPrimary.withOpacity(
                                    isDark ? 0.25 : 0.2,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .rotate(
                              duration: const Duration(seconds: 18),
                              curve: Curves.linear,
                            ),
                  ),
                ),

              // 3D Anime Graduate Character Asset
              Image.asset(
                'assets/images/developer_character_graduate.png',
                height: isMobile ? 220 : 270,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: isMobile ? 180 : 220,
                  height: isMobile ? 180 : 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EducationAwardBadge extends StatelessWidget {
  const _EducationAwardBadge();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF59E0B).withOpacity(isDark ? 0.22 : 0.14),
            AppColors.violetPrimary.withOpacity(isDark ? 0.16 : 0.08),
          ],
        ),
        color: isDark
            ? AppColors.darkCard.withOpacity(0.95)
            : Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF59E0B).withOpacity(isDark ? 0.6 : 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.22),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFFF59E0B),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Code Craft Excellence Award (2025)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFFDE68A)
                      : const Color(0xFFB45309),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Logix Built Infotech Solutions',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationCard extends StatefulWidget {
  final Education education;

  const _EducationCard({required this.education});

  @override
  State<_EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<_EducationCard> {
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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(_isHovered ? 1.018 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.violetPrimary : AppColors.cyanPrimary)
                  .withOpacity(_isHovered ? 0.32 : 0.06),
              blurRadius: _isHovered ? 24 : 10,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.violetPrimary.withOpacity(0.24)
                          : AppColors.violetPrimary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: AppColors.violetPrimary.withOpacity(
                                  0.35,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      color: isDark
                          ? AppColors.violetLight
                          : AppColors.violetDark,
                      size: 24,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4.5,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isDark ? AppColors.cyanPrimary : AppColors.cyanDark)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            (isDark
                                    ? AppColors.cyanPrimary
                                    : AppColors.cyanDark)
                                .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '${widget.education.startDate} – ${widget.education.endDate}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.cyanPrimary
                            : AppColors.cyanDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.education.degree,
                style: AppTypography.getTitleLarge(textColor)
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                widget.education.institution,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.violetLight : AppColors.violetDark,
                ),
              ),
              if (widget.education.affiliation.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  widget.education.affiliation,
                  style: TextStyle(fontSize: 12.5, color: secondaryTextColor),
                ),
              ],
              const SizedBox(height: 12),

              // Distinction / CGPA Badge
              if (widget.education.honors.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.education.honors,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.education.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  widget.education.description,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
