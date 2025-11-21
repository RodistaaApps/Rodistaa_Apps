import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/bids/my_bids_screen.dart';
import 'screens/bids/update_bid_screen.dart';
import 'screens/bookings/bookings_screen.dart';
import 'screens/bookings/place_bid_screen.dart';
import 'screens/bookings/place_bid_page.dart';
import 'screens/drivers/add_driver_screen.dart';
import 'screens/drivers/drivers_list_screen.dart';
import 'screens/fleet/add_truck_screen.dart';
import 'screens/fleet/assign_driver_screen.dart';
import 'screens/fleet/my_fleet_screen.dart';
import 'screens/fleet/truck_details_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/kyc_verification_screen.dart';
import 'screens/profile/notifications_screen.dart';
import 'screens/profile/transaction_history_screen.dart';
import 'screens/tickets/my_tickets_screen.dart';
import 'screens/tickets/create_ticket_screen.dart';
import 'screens/tickets/ticket_details_screen.dart';
import 'screens/profile/help_support_screen.dart';
import 'screens/profile/settings_screen.dart';
import 'screens/profile/privacy_policy_screen.dart';
import 'screens/profile/terms_conditions_screen.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/shipment/shipment_detail.dart';
import 'screens/shipment/active_shipments_screen.dart';
import 'screens/shipment/live_track_screen.dart';
import 'widgets/modern_bottom_nav.dart';
import 'theme/app_theme.dart';

GoRouter buildRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authProvider,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/fleet',
        builder: (context, state) => const MyFleetScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddTruckScreen(),
          ),
          GoRoute(
            path: ':truckId',
            builder: (context, state) => TruckDetailsScreen(
              truckId: state.pathParameters['truckId']!,
            ),
            routes: [
              GoRoute(
                path: 'assign-driver',
                builder: (context, state) => AssignDriverScreen(
                  truckId: state.pathParameters['truckId']!,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/drivers',
        builder: (context, state) => const DriversListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddDriverScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/bookings',
        builder: (context, state) => const BookingsScreen(),
        routes: [
          GoRoute(
            path: ':bookingId/bid',
            builder: (context, state) => PlaceBidScreen(
              bookingId: state.pathParameters['bookingId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/place-bid/:loadId',
        builder: (context, state) => PlaceBidPage(
          bookingId: state.pathParameters['loadId']!,
        ),
      ),
      GoRoute(
        path: '/bids',
        builder: (context, state) => const MyBidsScreen(),
        routes: [
          GoRoute(
            path: ':bidId/update',
            builder: (context, state) => UpdateBidScreen(
              bidId: state.pathParameters['bidId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/shipments',
        builder: (context, state) => const ActiveShipmentsScreen(),
      ),
      GoRoute(
        path: '/shipments/:shipmentId',
        builder: (context, state) => ShipmentDetailScreen(
          shipmentId: state.pathParameters['shipmentId']!,
        ),
        routes: [
          GoRoute(
            path: 'live-track',
            builder: (context, state) => LiveTrackScreen(
              shipmentId: state.pathParameters['shipmentId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/menu',
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const SizedBox.shrink(),
        redirect: (context, state) {
          if (state.fullPath == '/profile') {
            return '/home';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: 'kyc',
            builder: (context, state) => const KYCVerificationScreen(),
          ),
          GoRoute(
            path: 'transactions',
            builder: (context, state) => const TransactionHistoryScreen(),
          ),
          GoRoute(
            path: 'tickets',
            builder: (context, state) => const MyTicketsScreen(),
            routes: [
              GoRoute(
                path: ':ticketId',
                builder: (context, state) => TicketDetailsScreen(
                  ticketId: state.pathParameters['ticketId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'create-ticket',
            builder: (context, state) => const CreateTicketScreen(),
          ),
          GoRoute(
            path: 'help',
            builder: (context, state) => const HelpSupportScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: 'privacy',
            builder: (context, state) => const PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: 'terms',
            builder: (context, state) => const TermsConditionsScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final loggedIn = authProvider.isAuthenticated;
      final goingToLogin = state.uri.path == '/login';
      if (!loggedIn && !goingToLogin) {
        return '/login';
      }
      if (loggedIn && goingToLogin) {
        return '/home';
      }
      return null;
    },
  );
}

class RodistaaOperatorApp extends StatelessWidget {
  const RodistaaOperatorApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return MaterialApp.router(
      title: 'Rodistaa Operator',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: languageProvider.currentLocale,
      supportedLocales: AppConstants.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title screen is coming soon',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: ModernBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/bookings');
              break;
            case 2:
              context.go('/bids');
              break;
            case 3:
              // Already on shipments
              break;
            case 4:
              context.push('/menu');
              break;
          }
        },
      ),
    );
  }
}
