import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rodistaa_driver_app/screens/shipments_screen.dart';
import 'package:rodistaa_driver_app/services/shipment_api.dart';

import '../support/sample_shipment.dart';

class FakeShipmentApi extends ShipmentApi {
  int fetchCount = 0;
  ShipmentStatusFilter? latestStatus;

  @override
  Future<List<Map<String, dynamic>>> fetchShipments({
    required ShipmentStatusFilter status,
    int page = 1,
    AdvancedShipmentFilters? filters,
  }) async {
    fetchCount++;
    latestStatus = status;
    if (status == ShipmentStatusFilter.completed) {
      return [completedSampleShipment];
    }
    return [sampleShipment];
  }

  @override
  Future<Map<String, dynamic>> fetchShipmentDetails(String shipmentId) async {
    return shipmentId == completedSampleShipment['id']
        ? completedSampleShipment
        : sampleShipment;
  }
}

void main() {
  testWidgets('Segmented control triggers fetch', (tester) async {
    final api = FakeShipmentApi();
    await tester.pumpWidget(
      MaterialApp(
        home: ShipmentsScreen(api: api),
      ),
    );

    await tester.pumpAndSettle();
    final initialFetches = api.fetchCount;

    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    expect(api.fetchCount, greaterThan(initialFetches));
    expect(api.latestStatus, ShipmentStatusFilter.completed);
  });

  testWidgets('Completed tab updates header and tagline', (tester) async {
    final api = FakeShipmentApi();
    await tester.pumpWidget(
      MaterialApp(
        home: ShipmentsScreen(api: api),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    expect(find.text('Completed Shipments'), findsOneWidget);
    expect(find.text('Track your completed deliveries.'), findsOneWidget);
  });

  testWidgets('Completed card tap opens read-only bottom sheet', (tester) async {
    final api = FakeShipmentApi();
    await tester.pumpWidget(
      MaterialApp(
        home: ShipmentsScreen(
          api: api,
          initialStatus: ShipmentStatusFilter.completed,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('ID: #${completedSampleShipment['id']}'));
    await tester.pumpAndSettle();

    expect(find.text('Download Invoice'), findsOneWidget);
    expect(find.text('Raise Issue'), findsOneWidget);
  });
}

