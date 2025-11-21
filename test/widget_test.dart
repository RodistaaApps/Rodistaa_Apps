import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:rodistaa_operator_app/l10n/app_localizations.dart';
import 'package:rodistaa_operator_app/providers/auth_provider.dart';
import 'package:rodistaa_operator_app/providers/language_provider.dart';
import 'package:rodistaa_operator_app/screens/login_screen.dart';

void main() {
  testWidgets('Login screen renders send OTP button', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.textContaining('SEND'), findsWidgets);
  });
}
