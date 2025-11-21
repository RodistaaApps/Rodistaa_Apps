import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_bottom_navigation.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/brand_scaffold.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.message,
    required this.currentIndex,
  });

  final String title;
  final String message;
  final int currentIndex;

  void _handleNavigation(BuildContext context, int index) {
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
        context.go('/shipments');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BrandScaffold(
      backgroundColor: AppColors.white,
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: Text(
          title,
          style: AppTextStyles.header.copyWith(fontSize: 24),
        ),
        centerTitle: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        labels: [
          loc?.home ?? 'Home',
          loc?.bookings ?? 'Bookings',
          loc?.bids ?? 'My Bids',
          loc?.myShipments ?? 'Shipments',
        ],
        icons: const [
          Icons.home,
          Icons.manage_search,
          Icons.emoji_events,
          Icons.local_shipping,
        ],
        currentIndex: currentIndex,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }
}

