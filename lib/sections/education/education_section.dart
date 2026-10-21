import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/education.dart';
import '../../widgets/animations/staggered_entrance.dart';
import '../../widgets/cards/glass_card.dart';

/// Education section presenting verified degrees, universities, honors,
/// and academic foundation accompanied by the graduate character illustration.
class EducationSection extends StatelessWidget {
  final List<Education> education;

  const EducationSection({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = !isMobile && !isTablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final double? minEducationHeight = isDesktop
        ? math.max(620.0, screenHeight - 92.0)
        : null;

    return Container(
      constraints: minEducationHeight != null
          ? BoxConstraints(minHeight: minEducationHeight)
          : null,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 16 : (isMobile ? 24 : 28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
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
          const SizedBox(height: 10),
          Text(
            'Education & Qualifications',
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 26 : 32),
          ),
          const SizedBox(height: 6),
          Text(
            'Formal computer applications degrees with distinctions across university curricula.',
            style: AppTypography.getBodyLarge(secondaryTextColor),
          ),
          const SizedBox(height: 20),

          // Education Cards & 3D Graduate Character Stage
          if (isMobile)
            Column(
              children: [
                const StaggeredEntrance(
                  index: 0,
                  child: _EducationCharacterStage(isMobile: true),
                ),
                const SizedBox(height: 18),
                ...education.asMap().entries.map((entry) {
                  final index = entry.key;
                  final edu = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: StaggeredEntrance(
                      index: index + 1,
                      child: _EducationCard(education: edu),
                    ),
                  );
                }),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (education.isNotEmpty)
                  Expanded(
                    flex: 7,
                    child: StaggeredEntrance(
                      index: 0,
                      child: _EducationCard(education: education[0]),
                    ),
                  ),
                const SizedBox(width: 20),
                const Expanded(
                  flex: 6,
                  child: StaggeredEntrance(
                    index: 1,
                    child: _EducationCharacterStage(isMobile: false),
                  ),
                ),
                const SizedBox(width: 20),
                if (education.length > 1)
                  Expanded(
                    flex: 7,
                    child: StaggeredEntrance(
                      index: 2,
                      child: _EducationCard(education: education[1]),
                    ),
                  ),
              ],
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

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? 260 : 310,
          maxHeight: isMobile ? 270 : 330,
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Ambient glowing backdrop
            Container(
              width: isMobile ? 200 : 250,
              height: isMobile ? 200 : 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.violetPrimary.withOpacity(isDark ? 0.35 : 0.22),
                    const Color(0xFFF59E0B).withOpacity(isDark ? 0.2 : 0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
            // Outer subtle glass ring
            Container(
              width: isMobile ? 215 : 265,
              height: isMobile ? 215 : 265,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : AppColors.violetPrimary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
            // 3D Graduate anime developer illustration
            Image.asset(
              'assets/images/developer_character_graduate.png',
              height: isMobile ? 245 : 300,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
            // Floating distinction honors badge at bottom of character
            Positioned(
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkCard : Colors.white)
                      .withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withOpacity(0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFF59E0B),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Distinction Honors (MCA & BCA)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.darkBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final Education education;

  const _EducationCard({required this.education});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.violetPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: isDark ? AppColors.violetLight : AppColors.violetDark,
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.cyanPrimary : AppColors.cyanDark)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (isDark ? AppColors.cyanPrimary : AppColors.cyanDark)
                        .withOpacity(0.25),
                  ),
                ),
                child: Text(
                  '${education.startDate} – ${education.endDate}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.cyanPrimary : AppColors.cyanDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            education.degree,
            style: AppTypography.getTitleLarge(textColor)
                .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            education.institution,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.violetLight : AppColors.violetDark,
            ),
          ),
          if (education.affiliation.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              education.affiliation,
              style: TextStyle(fontSize: 12.5, color: secondaryTextColor),
            ),
          ],
          const SizedBox(height: 12),

          // Distinction / CGPA Badge
          if (education.honors.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
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
                  Text(
                    education.honors,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          if (education.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              education.description,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: secondaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
