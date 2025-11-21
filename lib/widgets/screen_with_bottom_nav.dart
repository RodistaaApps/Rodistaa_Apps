import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'modern_bottom_nav.dart';

class ScreenWithBottomNav extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const ScreenWithBottomNav({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/bookings');
        break;
      case 2:
        GoRouter.of(context).go('/bids');
        break;
      case 3:
        GoRouter.of(context).go('/shipments');
        break;
      case 4:
        GoRouter.of(context).push('/menu');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: ModernBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => _onBottomNavTap(context, index),
      ),
    );
  }
}

