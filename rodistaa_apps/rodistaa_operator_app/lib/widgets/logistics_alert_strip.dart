import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class LogisticsAlert {
  const LogisticsAlert({required this.icon, required this.message});

  final IconData icon;
  final String message;
}

class LogisticsAlertStrip extends StatefulWidget {
  const LogisticsAlertStrip({
    super.key,
    required this.alerts,
    this.interval = const Duration(seconds: 4),
  });

  final List<LogisticsAlert> alerts;
  final Duration interval;

  @override
  State<LogisticsAlertStrip> createState() => _LogisticsAlertStripState();
}

class _LogisticsAlertStripState extends State<LogisticsAlertStrip> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (widget.alerts.length <= 1) return;
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      _index = (_index + 1) % widget.alerts.length;
      if (_controller.hasClients) {
        _controller.animateToPage(
          _index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant LogisticsAlertStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.interval != widget.interval ||
        oldWidget.alerts.length != widget.alerts.length) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    // Match card height: with aspect ratio 1.5, cards will be approximately 100px tall
    return SizedBox(
      height: 100,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.alerts.length,
        itemBuilder: (context, index) {
          final alert = widget.alerts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(alert.icon, color: AppColors.primaryRed, size: 40),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      alert.message,
                      style: AppTextStyles.body.copyWith(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
