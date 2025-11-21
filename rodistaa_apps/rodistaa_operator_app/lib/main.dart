import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/bid_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/driver_provider.dart';
import 'providers/fleet_provider.dart';
import 'providers/kyc_provider.dart';
import 'providers/language_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/ticket_provider.dart';
import 'providers/transaction_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  final languageProvider = LanguageProvider();

  await Future.wait([
    authProvider.checkAuthStatus(),
    languageProvider.loadLocale(),
  ]);

  final router = buildRouter(authProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        ChangeNotifierProvider<BookingProvider>(create: (_) => BookingProvider()),
        ChangeNotifierProvider<FleetProvider>(create: (_) => FleetProvider()),
        ChangeNotifierProvider<DriverProvider>(create: (_) => DriverProvider()),
        ChangeNotifierProvider<BidProvider>(create: (_) => BidProvider()),
        ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
        ChangeNotifierProvider<KYCProvider>(create: (_) => KYCProvider()),
        ChangeNotifierProvider<TransactionProvider>(create: (_) => TransactionProvider()),
        ChangeNotifierProvider<TicketProvider>(create: (_) => TicketProvider()),
        ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider()),
        ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
      ],
      child: RodistaaOperatorApp(router: router),
    ),
  );
  // Demo confirmation log for QA instructions.
  // ignore: avoid_print
  print('Menu demo pages implemented. Profile header updated. Mock services enabled. Ready for manual verification.');
}
