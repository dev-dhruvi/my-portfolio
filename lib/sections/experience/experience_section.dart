import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/experience_calculator.dart';
import '../../models/experience.dart';
import '../../widgets/animations/staggered_entrance.dart';
import '../../widgets/cards/glass_card.dart';

/// Vertical timeline displaying verified work experience with merged
/// duration calculation and responsibilities from resumes.
class ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    // Calculate total cumulative experience across all ranges without double counting
    final ranges = experiences
        .map((e) => {'start': e.startDate, 'end': e.endDate})
        .toList();
    final totalExperienceFormatted =
        ExperienceCalculator.calculateTotalExperience(ranges);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                .copyWith(fontSize: isMobile ? 24 : 28),
          ),
          const SizedBox(height: 8),

          // Total Experience Duration Badge (avoiding double-counting overlapping periods)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                Text(
                  'Total Cumulative Experience: $totalExperienceFormatted (Verified intervals)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Timeline Items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              final exp = experiences[index];
              final isLast = index == experiences.length - 1;

              return StaggeredEntrance(
                index: index,
                child: _TimelineItem(
                  experience: exp,
                  isLast: isLast,
                  isMobile: isMobile,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatefulWidget {
  final Experience experience;
  final bool isLast;
  final bool isMobile;

  const _TimelineItem({
    required this.experience,
    required this.isLast,
    required this.isMobile,
  });

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isExpanded = false;

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
    final hasManyResponsibilities = responsibilities.length > 4;
    final displayedResponsibilities = (_isExpanded || !hasManyResponsibilities)
        ? responsibilities
        : responsibilities.take(4).toList();

    return Stack(
      children: [
        // Connecting Line from dot to bottom of item
        if (!widget.isLast)
          Positioned(
            top: 26,
            bottom: 0,
            left: 19,
            width: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.violetPrimary.withOpacity(0.6),
                    AppColors.cyanPrimary.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

        // Timeline Node Indicator Dot
        Positioned(
          top: 8,
          left: 9,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.violetPrimary, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.violetPrimary.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.cyanPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),

        // Experience Card Content
        Padding(
          padding: const EdgeInsets.only(left: 48.0, bottom: 24.0),
          child: GlassCard(
            padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Responsive Header Row/Column
                if (widget.isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.experience.role,
                        style: AppTypography.getTitleLarge(textColor)
                            .copyWith(fontWeight: FontWeight.w700),
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
                              fontSize: 15,
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
                            widget.experience.location,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDurationTag(),
                    ],
                  )
                else
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
                                  .copyWith(fontWeight: FontWeight.w700),
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
                                    fontSize: 15,
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
                                  widget.experience.location,
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildDurationTag(),
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
                            padding: EdgeInsets.only(top: 5.0, right: 8.0),
                            child: Icon(
                              Icons.arrow_right_rounded,
                              size: 18,
                              color: AppColors.violetPrimary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              resp,
                              style: AppTypography.getBodyMedium(
                                secondaryTextColor,
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
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isExpanded
                                ? 'Show fewer responsibilities'
                                : 'Show all ${responsibilities.length} responsibilities (+${responsibilities.length - 4} more)',
                            style: TextStyle(
                              fontSize: 12.5,
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
                            size: 16,
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

                // Award Badge (if present)
                if (widget.experience.award != null &&
                    widget.experience.award!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFF59E0B)
                              .withOpacity(isDark ? 0.18 : 0.12),
                          AppColors.violetPrimary.withOpacity(
                            isDark ? 0.15 : 0.08,
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFF59E0B)
                            .withOpacity(isDark ? 0.45 : 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.emoji_events_rounded,
                          size: 18,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.experience.award!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFFDE68A)
                                  : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Tech Stack Tags
                if (widget.experience.technologies.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.experience.technologies.map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
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
                            fontSize: 12,
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
      ],
    );
  }

  Widget _buildDurationTag() {
    return Column(
      crossAxisAlignment: widget.isMobile
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cyanPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cyanPrimary.withOpacity(0.25)),
          ),
          child: Text(
            '${widget.experience.startDate} – ${widget.experience.endDate}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.cyanPrimary,
            ),
          ),
        ),
        if (widget.experience.calculatedDuration.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            widget.experience.calculatedDuration,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ],
    );
  }
}
