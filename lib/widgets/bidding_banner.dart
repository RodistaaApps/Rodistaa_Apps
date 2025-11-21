import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class BiddingBanner extends StatefulWidget {
  const BiddingBanner({super.key});

  @override
  State<BiddingBanner> createState() => _BiddingBannerState();
}

class _BiddingBannerState extends State<BiddingBanner> {
  final quotes = [
    'Win More Bids, Earn More! Place competitive bids and grow your business.',
    'Fast Shipments, Happy Customers. Track your deliveries in real-time.',
    'Zero Commission, Maximum Profit. Bid smart and ship efficiently.',
  ];
  
  int _currentQuote = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Rotate quotes every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _currentQuote = (_currentQuote + 1) % quotes.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryRed.withValues(alpha: 0.95),
            AppColors.primaryRed.withValues(alpha: 0.85),
            const Color(0xFFFCEAEA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Truck cartoon illustration placeholder (using icon as placeholder)
            Positioned(
              right: -20,
              top: -10,
              child: Opacity(
                opacity: 0.25,
                child: Icon(
                  Icons.local_shipping,
                  size: 180,
                  color: Colors.white,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.gavel,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RODISTAA',
                              style: AppTextStyles.title.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                quotes[_currentQuote],
                                key: ValueKey(_currentQuote),
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

