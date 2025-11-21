import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/colors.dart';

class HomeTruckAnimation extends StatefulWidget {
  const HomeTruckAnimation({super.key});

  @override
  State<HomeTruckAnimation> createState() => _HomeTruckAnimationState();
}

class _HomeTruckAnimationState extends State<HomeTruckAnimation> {
  final PageController _pageController = PageController();
  final List<_TruckFrame> _frames = const [
    _TruckFrame(asset: 'assets/images/rodistaa_banner.png', alignment: Alignment.centerLeft),
    _TruckFrame(asset: 'assets/images/rodistaa_banner.png', alignment: Alignment.center),
    _TruckFrame(asset: 'assets/images/rodistaa_banner.png', alignment: Alignment.centerRight),
  ];
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _current = (_current + 1) % _frames.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _current,
          duration: const Duration(milliseconds: 450),
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
    return SizedBox(
      height: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _frames.length,
              itemBuilder: (context, index) {
                final frame = _frames[index];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryRed.withValues(alpha: 0.92),
                        AppColors.primaryRed.withValues(alpha: 0.65),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Align(
                    alignment: frame.alignment,
                    child: Image.asset(
                      frame.asset,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_frames.length, (index) {
                  final active = index == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TruckFrame {
  const _TruckFrame({required this.asset, required this.alignment});

  final String asset;
  final Alignment alignment;
}
