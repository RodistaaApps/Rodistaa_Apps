import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rodistaa_driver_app/widgets/shipment_card_final.dart';

import '../support/sample_shipment.dart';

void main() {
  testWidgets('ShipmentCardFinal renders main sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(child: SingleChildScrollView(child: ShipmentCardFinal(shipment: sampleShipment))),
      ),
    );

    expect(find.text('#SHIP123456'), findsOneWidget);
    expect(find.text('Pickup'), findsWidgets);
    expect(find.text('Drop'), findsWidgets);
    expect(find.text('View Details'), findsOneWidget);
  });

  testWidgets('View Details opens bottom sheet', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShipmentCardFinal(shipment: sampleShipment),
        ),
      ),
    );

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    expect(find.text('Truck Details'), findsOneWidget);
  });
}


