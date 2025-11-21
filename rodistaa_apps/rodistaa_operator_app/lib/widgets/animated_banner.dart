import 'package:flutter/material.dart';
import '../constants/colors.dart';

// Brand colors for banner
final Color rodistaaRed = AppColors.primaryRed;
final Color softPink = const Color(0xFFFCEAEA);
final Color pickupGreen = const Color(0xFF00C853);

class AnimatedBanner extends StatefulWidget {
  /// Optional marquee text - will not change app copy
  final String? marqueeText;

  const AnimatedBanner({super.key, this.marqueeText});

  @override
  State<AnimatedBanner> createState() => _AnimatedBannerState();
}

class _AnimatedBannerState extends State<AnimatedBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = 64.0;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: height,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            // Shift gradient stops slightly over time and give a micro-vertical movement
            final t = _anim.value;
            final offset = (t - 0.5) * 6; // -3 .. +3 px

            return Transform.translate(
              offset: Offset(0, offset),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + t * 0.2, 0),
                    end: Alignment(1 - t * 0.2, 0),
                    colors: [
                      rodistaaRed.withValues(alpha: 0.95),
                      softPink.withValues(alpha: 0.9),
                      Colors.white.withValues(alpha: 0.9)
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Decorative icon with subtle scale animation
                    Transform.scale(
                      scale: 0.95 + 0.05 * t,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.local_shipping, color: rodistaaRed, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Marquee/text slot (do not replace app copy here)
                    Expanded(
                      child: _buildMarquee(widget.marqueeText ?? ''),
                    ),
                    // small CTA placeholder (non-functional)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'View',
                        style: TextStyle(
                          color: rodistaaRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMarquee(String text) {
    if (text.isEmpty) {
      // default decorative copy — still not changing app strings
      return const Text(' ', style: TextStyle(fontFamily: 'TimesNewRoman'));
    }

    // simple sliding text using Transform.translate
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        return AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            final dx = (1 - _anim.value) * maxW * 0.3; // subtle shift, not full marquee
            return Transform.translate(
              offset: Offset(-dx, 0),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

