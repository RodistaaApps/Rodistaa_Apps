import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:rodistaa_operator_app/models/booking.dart';
import 'package:rodistaa_operator_app/providers/bid_provider.dart';
import 'package:rodistaa_operator_app/providers/booking_provider.dart';
import 'package:rodistaa_operator_app/providers/fleet_provider.dart';
import 'package:rodistaa_operator_app/screens/bookings/place_bid_sheet.dart';

void main() {
  group('PlaceBidSheet', () {
    late Booking testBooking;
    late BookingProvider bookingProvider;
    late BidProvider bidProvider;
    late FleetProvider fleetProvider;

    setUp(() {
      bookingProvider = BookingProvider();
      bidProvider = BidProvider();
      fleetProvider = FleetProvider();

      // Get first available booking from mock data
      final bookings = bookingProvider.availableBookings;
      if (bookings.isNotEmpty) {
        testBooking = bookings.first;
      } else {
        // Fallback test booking if no mock data
        testBooking = Booking(
          bookingId: 'BK001',
          customerId: 'CUST001',
          customerName: 'Test Customer',
          fromCity: 'Bangalore',
          fromPincode: '560001',
          toCity: 'Chennai',
          toPincode: '600001',
          distance: 350.0,
          weight: 5.5,
          materialType: 'Electronics',
          requiredTruckType: '10 Tyre',
          pickupDate: DateTime.now().add(const Duration(days: 1)),
          minBudget: 10000.0,
          maxBudget: 20000.0,
          totalBids: 0,
          status: 'open',
          postedDate: DateTime.now(),
        );
      }
    });

    testWidgets('renders load summary header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: bookingProvider),
              ChangeNotifierProvider.value(value: bidProvider),
              ChangeNotifierProvider.value(value: fleetProvider),
            ],
            child: Scaffold(
              body: PlaceBidSheet(bookingId: testBooking.bookingId),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify load ID is displayed
      expect(find.text('LOAD #${testBooking.bookingId}'), findsOneWidget);

      // Verify route is displayed
      expect(find.text('${testBooking.fromCity} → ${testBooking.toCity}'), findsOneWidget);
    });

    testWidgets('renders estimated charges section', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: bookingProvider),
              ChangeNotifierProvider.value(value: bidProvider),
              ChangeNotifierProvider.value(value: fleetProvider),
            ],
            child: Scaffold(
              body: PlaceBidSheet(bookingId: testBooking.bookingId),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Estimated Freight Charge title
      expect(find.text('Estimated Freight Charge'), findsOneWidget);

      // Verify toll estimate label
      expect(find.text('Toll estimate'), findsOneWidget);

      // Verify fuel estimate label
      expect(find.text('Estimated fuel'), findsOneWidget);

      // Verify total label
      expect(find.text('Total (est.)'), findsOneWidget);
    });

    testWidgets('renders price guidance slider', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: bookingProvider),
              ChangeNotifierProvider.value(value: bidProvider),
              ChangeNotifierProvider.value(value: fleetProvider),
            ],
            child: Scaffold(
              body: PlaceBidSheet(bookingId: testBooking.bookingId),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Price Guidance title
      expect(find.text('Price Guidance'), findsOneWidget);
    });

    testWidgets('renders quotation input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: bookingProvider),
              ChangeNotifierProvider.value(value: bidProvider),
              ChangeNotifierProvider.value(value: fleetProvider),
            ],
            child: Scaffold(
              body: PlaceBidSheet(bookingId: testBooking.bookingId),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Your Quotation title
      expect(find.text('Your Quotation'), findsOneWidget);

      // Verify input field placeholder
      expect(find.text('Enter your bid'), findsOneWidget);
    });

    testWidgets('renders truck selection section', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: bookingProvider),
              ChangeNotifierProvider.value(value: bidProvider),
              ChangeNotifierProvider.value(value: fleetProvider),
            ],
            child: Scaffold(
              body: PlaceBidSheet(bookingId: testBooking.bookingId),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Select Your Truck title
      expect(find.text('Select Your Truck'), findsOneWidget);

      // Verify truck selector button
      expect(find.text('Choose truck from MyFleet'), findsOneWidget);
    });

    testWidgets('renders Cancel and Place Bid buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: bookingProvider),
              ChangeNotifierProvider.value(value: bidProvider),
              ChangeNotifierProvider.value(value: fleetProvider),
            ],
            child: Scaffold(
              body: PlaceBidSheet(bookingId: testBooking.bookingId),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Cancel button
      expect(find.text('Cancel'), findsOneWidget);

      // Verify Place Bid button
      expect(find.text('Place Bid'), findsOneWidget);
    });

    testWidgets('Place Bid button is disabled when truck not selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: bookingProvider),
              ChangeNotifierProvider.value(value: bidProvider),
              ChangeNotifierProvider.value(value: fleetProvider),
            ],
            child: Scaffold(
              body: PlaceBidSheet(bookingId: testBooking.bookingId),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find Place Bid button
      final placeBidButton = find.widgetWithText(ElevatedButton, 'Place Bid');
      expect(placeBidButton, findsOneWidget);

      // Button should be disabled (null onPressed when disabled)
      final button = tester.widget<ElevatedButton>(placeBidButton);
      expect(button.onPressed, isNull);
    });
  });
}

