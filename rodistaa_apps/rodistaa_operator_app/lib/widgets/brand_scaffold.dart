import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animated_banner.dart';
import 'modern_bottom_nav.dart';

/// Brand scaffold that wraps content with animated banner above bottom navigation
class BrandScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final int? bottomNavIndex;
  final ValueChanged<int>? onBottomNavTap;
  final String? bannerMarqueeText;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool showBanner;

  const BrandScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.bottomNavIndex,
    this.onBottomNavTap,
    this.bannerMarqueeText,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.showBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasBottomNav = bottomNavigationBar != null ||
        (bottomNavIndex != null && onBottomNavTap != null);

    Widget content = body;

    // If we have bottom navigation, wrap with banner
    final shouldShowBanner = showBanner && ThemeConfig.showAnimatedBanner;

    if (hasBottomNav && shouldShowBanner) {
      content = Column(
        children: [
          Expanded(child: body),
          AnimatedBanner(marqueeText: bannerMarqueeText),
          if (bottomNavigationBar != null)
            bottomNavigationBar!
          else if (bottomNavIndex != null && onBottomNavTap != null)
            ModernBottomNav(
              currentIndex: bottomNavIndex!,
              onTap: onBottomNavTap!,
            ),
        ],
      );
    } else if (hasBottomNav) {
      // No banner, just bottom nav
      content = Column(
        children: [
          Expanded(child: body),
          if (bottomNavigationBar != null)
            bottomNavigationBar!
          else if (bottomNavIndex != null && onBottomNavTap != null)
            ModernBottomNav(
              currentIndex: bottomNavIndex!,
              onTap: onBottomNavTap!,
            ),
        ],
      );
    }

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      body: content,
    );
  }
}

