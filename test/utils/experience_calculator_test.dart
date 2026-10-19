import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/core/utils/experience_calculator.dart';

void main() {
  group('ExperienceCalculator Tests', () {
    test('calculateSingleDuration computes correct duration', () {
      // June 2024 to April 2025 = 11 months
      final duration1 = ExperienceCalculator.calculateSingleDuration(
        'June 2024',
        'April 2025',
      );
      expect(duration1, equals('11 mos'));

      // June 2022 to May 2024 = 2 years
      final duration2 = ExperienceCalculator.calculateSingleDuration(
        'June 2022',
        'May 2024',
      );
      expect(duration2, equals('2 yrs'));

      // January 2022 to May 2022 = 5 months
      final duration3 = ExperienceCalculator.calculateSingleDuration(
        'January 2022',
        'May 2022',
      );
      expect(duration3, equals('5 mos'));
    });

    test(
      'calculateSingleDuration handles invalid or empty dates gracefully',
      () {
        expect(ExperienceCalculator.calculateSingleDuration('', ''), isEmpty);
        expect(
          ExperienceCalculator.calculateSingleDuration('invalid', 'dates'),
          isEmpty,
        );
      },
    );

    test(
      'calculateTotalExperience avoids double-counting overlapping intervals',
      () {
        // Test two overlapping jobs:
        // Job A: Jan 2023 - Dec 2023 (12 months)
        // Job B: Jun 2023 - Jun 2024 (13 months)
        // Merged: Jan 2023 - Jun 2024 = 18 months = 1 yr 6 mos (NOT 25 months)
        final ranges = [
          {'start': 'Jan 2023', 'end': 'Dec 2023'},
          {'start': 'Jun 2023', 'end': 'Jun 2024'},
        ];

        final total = ExperienceCalculator.calculateTotalExperience(ranges);
        expect(total, equals('1 yr 6 mos'));
      },
    );

    test(
      'calculateTotalExperience handles contiguous and disjoint intervals',
      () {
        final ranges = [
          {'start': 'Jan 2022', 'end': 'May 2022'}, // 5 mos
          {'start': 'Jun 2022', 'end': 'May 2024'}, // 24 mos (contiguous)
        ];

        final total = ExperienceCalculator.calculateTotalExperience(ranges);
        // Jan 2022 to May 2024 = 29 months = 2 yrs 5 mos
        expect(total, equals('2 yrs 5 mos'));
      },
    );
  });
}
