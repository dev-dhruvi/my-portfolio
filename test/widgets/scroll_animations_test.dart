import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/widgets/animations/parallax_widget.dart';
import 'package:dhruvi_portfolio/widgets/animations/scroll_progress_indicator.dart';
import 'package:dhruvi_portfolio/widgets/animations/scroll_reveal.dart';

void main() {
  group('Scroll-Driven Animation Tests', () {
    testWidgets('ScrollProgressIndicator calculates progress on scroll', (
      tester,
    ) async {
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: Container(height: 2000, color: Colors.blue),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ScrollProgressIndicator(
                    scrollController: scrollController,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ScrollProgressIndicator), findsOneWidget);

      // Scroll halfway down
      scrollController.jumpTo(500);
      await tester.pump();
      expect(find.byType(ScrollProgressIndicator), findsOneWidget);

      // Verify indicator hides when animations are disabled
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: ScrollProgressIndicator(scrollController: scrollController),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FractionallySizedBox), findsNothing);
    });

    testWidgets('ParallaxWidget renders child and respects accessibility', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParallaxWidget(
              speed: 0.1,
              maxOffset: 25.0,
              child: Text('Parallax Child Content'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Parallax Child Content'), findsOneWidget);

      // Disabled animation mode test
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: ParallaxWidget(child: Text('Accessibility Mode Child')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Accessibility Mode Child'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ParallaxWidget),
          matching: find.byType(Transform),
        ),
        findsNothing,
      );
    });

    testWidgets(
      'ScrollReveal reveals content and supports clippedText factory',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ScrollReveal.clippedText(
                      child: Text('Headline Mask Reveal'),
                    ),
                    SizedBox(height: 50),
                    ScrollReveal(
                      staggerIndex: 1,
                      slideDistance: 20.0,
                      child: Text('Staggered Card Content'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Headline Mask Reveal'), findsOneWidget);
        expect(find.text('Staggered Card Content'), findsOneWidget);
        expect(find.byType(ClipRect), findsWidgets);

        // Instant render when disableAnimations is true
        await tester.pumpWidget(
          const MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: ScrollReveal(child: Text('Instant Accessible Render')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Instant Accessible Render'), findsOneWidget);
      },
    );
  });
}
