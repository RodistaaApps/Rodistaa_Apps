import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rodistaa_operator_app/widgets/compact_load_card.dart';

void main() {
  group('CompactLoadCard', () {
    testWidgets('renders load ID, route, and basic info', (WidgetTester tester) async {
      const loadId = 'LOAD123';
      const pickup = 'Bangalore';
      const drop = 'Chennai';
      const category = 'Electronics';
      const tons = 5.5;
      const bodyType = 'Open';
      const tyreCount = 10;
      final bidEndsAt = DateTime.now().add(const Duration(hours: 2));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactLoadCard(
              loadId: loadId,
              pickup: pickup,
              drop: drop,
              category: category,
              tons: tons,
              bodyType: bodyType,
              tyreCount: tyreCount,
              bidEndsAt: bidEndsAt,
              isFTL: true,
              onPlaceBid: () {},
            ),
          ),
        ),
      );

      // Verify load ID is displayed
      expect(find.text('LOAD #$loadId'), findsOneWidget);

      // Verify route is displayed
      expect(find.text('$pickup → $drop'), findsOneWidget);

      // Verify category is displayed
      expect(find.text(category), findsOneWidget);

      // Verify FTL badge is displayed
      expect(find.text('FTL'), findsOneWidget);

      // Verify card is tappable (Place Bid functionality moved to card tap)
    });

    testWidgets('displays PTL badge when isFTL is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactLoadCard(
              loadId: 'LOAD123',
              pickup: 'Bangalore',
              drop: 'Chennai',
              category: 'Electronics',
              tons: 3.0,
              bodyType: 'Closed',
              tyreCount: 6,
              bidEndsAt: DateTime.now().add(const Duration(hours: 2)),
              isFTL: false,
              onPlaceBid: () {},
            ),
          ),
        ),
      );

      // Verify PTL badge is displayed
      expect(find.text('PTL'), findsOneWidget);
      expect(find.text('FTL'), findsNothing);
    });

    testWidgets('calls onPlaceBid when card is tapped', (WidgetTester tester) async {
      bool bidPlaced = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactLoadCard(
              loadId: 'LOAD123',
              pickup: 'Bangalore',
              drop: 'Chennai',
              category: 'Electronics',
              tons: 5.5,
              bodyType: 'Open',
              tyreCount: 10,
              bidEndsAt: DateTime.now().add(const Duration(hours: 2)),
              isFTL: true,
              onPlaceBid: () {
                bidPlaced = true;
              },
            ),
          ),
        ),
      );

      // Tap the card (anywhere on it)
      await tester.tap(find.text('LOAD #LOAD123'));
      await tester.pump();

      expect(bidPlaced, isTrue);
    });

    // Share button removed from card - now available in place bid page

    testWidgets('displays countdown timer', (WidgetTester tester) async {
      final bidEndsAt = DateTime.now().add(const Duration(hours: 2, minutes: 30, seconds: 45));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactLoadCard(
              loadId: 'LOAD123',
              pickup: 'Bangalore',
              drop: 'Chennai',
              category: 'Electronics',
              tons: 5.5,
              bodyType: 'Open',
              tyreCount: 10,
              bidEndsAt: bidEndsAt,
              isFTL: true,
              onPlaceBid: () {},
            ),
          ),
        ),
      );

      // Verify timer icon is present
      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    });

    testWidgets('displays weight, body type, and tyre count', (WidgetTester tester) async {
      const tons = 8.5;
      const bodyType = 'Closed';
      const tyreCount = 14;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactLoadCard(
              loadId: 'LOAD123',
              pickup: 'Bangalore',
              drop: 'Chennai',
              category: 'Electronics',
              tons: tons,
              bodyType: bodyType,
              tyreCount: tyreCount,
              bidEndsAt: DateTime.now().add(const Duration(hours: 2)),
              isFTL: true,
              onPlaceBid: () {},
            ),
          ),
        ),
      );

      // Verify weight is displayed
      expect(find.text('${tons.toStringAsFixed(1)}T'), findsOneWidget);

      // Verify body type is displayed
      expect(find.text(bodyType), findsOneWidget);

      // Verify tyre count is displayed
      expect(find.text('$tyreCount tyres'), findsOneWidget);
    });
  });
}

