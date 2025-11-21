import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rodistaa_driver_app/widgets/otp_input.dart';

void main() {
  testWidgets('OtpInput auto advances and submits when filled', (tester) async {
    String? submittedOtp;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpInput(
            onSubmit: (otp) async => submittedOtp = otp,
            onCancel: () {},
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), '1');
    await tester.enterText(find.byType(TextField).at(1), '2');
    await tester.enterText(find.byType(TextField).at(2), '3');
    await tester.enterText(find.byType(TextField).at(3), '4');
    await tester.pumpAndSettle();

    expect(submittedOtp, '1234');
  });

  testWidgets('OtpInput distributes pasted value', (tester) async {
    String? submittedOtp;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpInput(
            onSubmit: (otp) async => submittedOtp = otp,
            onCancel: () {},
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, '9876');
    await tester.pumpAndSettle();

    expect(submittedOtp, '9876');
  });

  testWidgets('OtpInput moves focus back on delete', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpInput(
            onSubmit: (_) async {},
            onCancel: () {},
          ),
        ),
      ),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '1');
    await tester.enterText(fields.at(1), '2');
    await tester.pump();

    await tester.enterText(fields.at(1), '');
    await tester.pump();

    expect(tester.widget<TextField>(fields.at(0)).focusNode?.hasFocus, isTrue);
  });
}


