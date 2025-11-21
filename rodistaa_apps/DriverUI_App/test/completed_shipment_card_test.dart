import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rodistaa_driver_app/widgets/completed_shipment_card.dart';

import 'support/sample_shipment.dart';

void main() {
  testWidgets('CompletedShipmentCard renders addresses and rating', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: CompletedShipmentCard(
            shipment: completedSampleShipment,
          ),
        ),
      ),
    );

    expect(find.text('ID: #SHIP654321'), findsOneWidget);
    expect(find.textContaining('123 Industrial Park'), findsOneWidget);
    expect(find.textContaining('456 Commerce St'), findsOneWidget);
    expect(find.text('Full Truck'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNWidgets(5));
  });
}


