import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/home_action_card.dart';
import '../../widgets/logistics_alert_strip.dart';
import '../../widgets/brand_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _notificationCount = 4;
  Timer? _promoBannerTimer;
  int _currentPromoIndex = 0;

  final List<LogisticsAlert> _alerts = const [
    LogisticsAlert(icon: Icons.article_outlined, message: 'RC expiring for KA01AB1234 in 5 days'),
    LogisticsAlert(icon: Icons.contact_page_outlined, message: 'Driver license renewal due for Raju Kumar'),
    LogisticsAlert(icon: Icons.local_shipping_outlined, message: 'Trip BLR → CHN starting at 6:00 PM'),
    LogisticsAlert(icon: Icons.gavel_outlined, message: '2 bids pending review'),
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Bid Received',
      'message': 'You have received a new bid for shipment #12345',
      'time': '2 minutes ago',
      'icon': Icons.gavel_outlined,
      'isRead': false,
    },
    {
      'title': 'Driver Assigned',
      'message': 'Driver Raju Kumar has been assigned to trip BLR → CHN',
      'time': '15 minutes ago',
      'icon': Icons.person_outline,
      'isRead': false,
    },
    {
      'title': 'RC Expiring Soon',
      'message': 'RC for vehicle KA01AB1234 is expiring in 5 days',
      'time': '1 hour ago',
      'icon': Icons.article_outlined,
      'isRead': false,
    },
    {
      'title': 'Payment Received',
      'message': 'Payment of ₹15,000 received for shipment #12340',
      'time': '2 hours ago',
      'icon': Icons.payment_outlined,
      'isRead': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _notificationCount = _notifications.where((n) => n['isRead'] == false).length;
    _startPromoBannerAutoScroll();
  }

  void _startPromoBannerAutoScroll() {
    _promoBannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _currentPromoIndex = (_currentPromoIndex + 1) % 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _promoBannerTimer?.cancel();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
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
        setState(() => _selectedIndex = 0);
        break;
    }
  }

  void _openNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.3)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: AppTextStyles.title.copyWith(fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _notifications.isEmpty
                  ? Center(
                      child: Text(
                        'No notifications',
                        style: AppTextStyles.body.copyWith(color: AppColors.muteGray),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notifications.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: (notification['isRead'] as bool)
                                ? AppColors.white
                                : AppColors.surfaceGray.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderGray.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  notification['icon'] as IconData,
                                  color: AppColors.primaryRed,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification['title'] as String,
                                      style: AppTextStyles.title.copyWith(
                                        fontSize: 16,
                                        fontWeight: (notification['isRead'] as bool)
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification['message'] as String,
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.muteGray,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification['time'] as String,
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.muteGray,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!(notification['isRead'] as bool))
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryRed,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: My Fleet, Drivers
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _MyFleetActionButton(
                onTap: () => GoRouter.of(context).go('/fleet'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DriversActionButton(
                onTap: () => GoRouter.of(context).go('/drivers'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Bookings, My Bids
        Row(
          children: [
            Expanded(
              child: HomeActionCard(
                icon: Icons.assignment_outlined,
                label: 'Bookings',
                onTap: () => GoRouter.of(context).go('/bookings'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HomeActionCard(
                icon: Icons.currency_rupee,
                label: 'My Bids',
                onTap: () => GoRouter.of(context).go('/bids'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 3: Shipments, Alerts
        Row(
          children: [
            Expanded(
              child: HomeActionCard(
                icon: Icons.local_shipping,
                label: 'Shipments',
                onTap: () => GoRouter.of(context).go('/shipments'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LogisticsAlertStrip(alerts: _alerts),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 4: Scrolling promotional banners
        _buildPromoBannersRow(context),
      ],
    );
  }

  Widget _buildPromoBannersRow(BuildContext context) {
    final banners = [
      {
        'title': 'Zero Commission',
        'subtitle': 'Bid and ship with no hidden fees',
        'icon': Icons.monetization_on,
        'color': AppColors.primaryRed,
      },
      {
        'title': 'Real-time Tracking',
        'subtitle': 'Monitor your shipments live',
        'icon': Icons.my_location,
        'color': AppColors.primaryRed,
      },
      {
        'title': 'Fast Payments',
        'subtitle': 'Get paid quickly after delivery',
        'icon': Icons.payment,
        'color': AppColors.primaryRed,
      },
      {
        'title': '24/7 Support',
        'subtitle': 'We are here to help you always',
        'icon': Icons.support_agent,
        'color': AppColors.primaryRed,
      },
    ];
    final banner = banners[_currentPromoIndex];

    return SizedBox(
      height: 140,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey(_currentPromoIndex),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryRed,
                Color(0xFF7A0404),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  banner['icon'] as IconData,
                  color: Colors.white,
                  size: 52,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner['title'] as String,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      banner['subtitle'] as String,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BrandScaffold(
      bottomNavIndex: _selectedIndex,
      onBottomNavTap: _onBottomNavTap,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hero Banner - Large red header area
                    _HeroBanner(
                      notificationCount: _notificationCount,
                      onNotificationTap: _openNotifications,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Action Buttons Grid (2 rows: Fleet/Drivers/Alerts, Bookings/Bids/Shipments)
                          _buildActionGrid(context),
                        ],
                      ),
                    ),
                    // Add bottom padding to prevent content from being cut off
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}

// Removed _ServiceTile and _PromoCard widgets - using old 7-button layout

class _HeroBanner extends StatefulWidget {
  const _HeroBanner({
    required this.notificationCount,
    required this.onNotificationTap,
  });

  final int notificationCount;
  final VoidCallback onNotificationTap;

  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Win More Bids, Earn More!',
      'subtitle': 'Place competitive bids and grow your business.',
      'icon': Icons.handshake,
    },
    {
      'title': 'Fast Shipments, Happy Customers',
      'subtitle': 'Track your deliveries in real-time.',
      'icon': Icons.local_shipping,
    },
    {
      'title': 'Zero Commission, Maximum Profit',
      'subtitle': 'Bid smart and ship efficiently.',
      'icon': Icons.monetization_on,
    },
    {
      'title': 'Real-time Tracking',
      'subtitle': 'Monitor your shipments live.',
      'icon': Icons.my_location,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (_banners.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted && _pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % _banners.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRed,
            Color(0xFF8B0505),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          // Auto-scrolling banners
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        banner['icon'] as IconData,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner['title'] as String,
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner['subtitle'] as String,
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Page indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
          // Notification icon
          Positioned(
            top: 16,
            right: 16,
            child: Stack(
              children: [
                IconButton(
                  onPressed: widget.onNotificationTap,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                if (widget.notificationCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        widget.notificationCount > 9 ? '9+' : widget.notificationCount.toString(),
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyFleetActionButton extends StatelessWidget {
  const _MyFleetActionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'My Fleet',
      child: GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive cap: icon will never exceed half of available width if narrow
            final double iconMaxSize = 500.0;
            final double computedSize = (constraints.maxWidth / 2).clamp(96.0, iconMaxSize);
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Image
                    Image.asset(
                      'assets/images/myfleet_button.jpg',
                      width: computedSize,
                      height: computedSize,
                      fit: BoxFit.contain,
                    ),
                    // Text positioned on the image at the bottom edge
                    Positioned(
                      bottom: -14, // Positioned below the image edge
                      left: 0,
                      right: 0,
                      child: Text(
                        'My Fleet',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Small vertical spacing to next row to avoid touching neighbors
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DriversActionButton extends StatelessWidget {
  const _DriversActionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Drivers',
      child: GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive cap: icon will never exceed half of available width if narrow
            final double iconMaxSize = 500.0;
            final double computedSize = (constraints.maxWidth / 2).clamp(96.0, iconMaxSize);
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'assets/images/drivers_button.png',
                      width: computedSize,
                      height: computedSize,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      bottom: -14,
                      left: 0,
                      right: 0,
                      child: Text(
                        'Drivers',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Small vertical spacing to next row to avoid touching neighbors
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}


