import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/shipments/screens/my_shipments_screen.dart';
import '../../features/shipments/screens/live_tracking_screen.dart';
import '../../features/shipments/screens/shipment_details_screen.dart';
import '../../features/shipments/models/shipment_model.dart';
import '../../features/profile/screens/driver_profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/kyc_fullscreen.dart';
import '../../features/profile/screens/tickets_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String myShipments = '/my-shipments';
  static const String profile = '/profile';
  static const String liveTracking = '/live-tracking';
  static const String shipmentDetails = '/shipment-details';
  static const String notifications = '/notifications';
  static const String editProfile = '/edit-profile';
  static const String kycVerification = '/kyc';
  static const String tickets = '/tickets';
  static const String settings = '/settings';

  static GoRouter get router {
    return GoRouter(
      initialLocation: login,
      routes: [
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: myShipments,
          name: 'my-shipments',
          builder: (context, state) {
            final tab = state.uri.queryParameters['tab'];
            return MyShipmentsScreen(initialTab: tab);
          },
        ),
        GoRoute(
          path: '$liveTracking/:id',
          name: 'live-tracking',
          builder: (context, state) {
            final shipment = state.extra as Shipment?;
            if (shipment != null) {
              return LiveTrackingScreen(shipment: shipment);
            }
            return const Scaffold(
              body: Center(child: Text('Shipment not found')),
            );
          },
        ),
        GoRoute(
          path: '$shipmentDetails/:id',
          name: 'shipment-details',
          builder: (context, state) {
            final shipment = state.extra as Shipment?;
            if (shipment != null) {
              return ShipmentDetailsScreen(shipment: shipment);
            }
            return const Scaffold(
              body: Center(child: Text('Shipment not found')),
            );
          },
        ),
        GoRoute(
          path: profile,
          name: 'profile',
          builder: (context, state) => const DriverProfileScreen(),
        ),
        GoRoute(
          path: editProfile,
          name: 'edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: kycVerification,
          name: 'kyc',
          builder: (context, state) => const KycFullScreen(),
        ),
        GoRoute(
          path: tickets,
          name: 'tickets',
          builder: (context, state) => const TicketsScreen(),
        ),
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: notifications,
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
      ],
    );
  }
}
