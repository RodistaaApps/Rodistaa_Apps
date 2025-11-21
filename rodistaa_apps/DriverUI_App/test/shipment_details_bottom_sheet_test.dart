import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rodistaa_driver_app/widgets/shipment_details_bottom_sheet.dart';

import 'support/sample_shipment.dart';

void main() {
  testWidgets('ShipmentDetailsBottomSheet readOnly shows invoice actions', (tester) async {
    final controller = ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: ShipmentDetailsBottomSheet(
          shipment: sampleShipment,
          controller: controller,
          readOnly: true,
          onDownloadInvoice: (_) async => Uri.parse('https://example.com'),
          onRaiseIssue: (_, {required subject, required description, String? attachmentPath}) async {},
        ),
      ),
    );

    expect(find.text('Download Invoice'), findsOneWidget);
    expect(find.text('Raise Issue'), findsOneWidget);
  });
}

