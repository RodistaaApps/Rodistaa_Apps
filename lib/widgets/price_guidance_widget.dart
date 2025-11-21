import 'package:flutter/material.dart';

import '../constants/colors.dart';

class PriceGuidanceWidget extends StatefulWidget {
  const PriceGuidanceWidget({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.suggestedValue,
    required this.currentValue,
    required this.onChanged,
  });

  final double minValue;
  final double maxValue;
  final double suggestedValue;
  final double currentValue;
  final ValueChanged<double> onChanged;

  @override
  State<PriceGuidanceWidget> createState() => _PriceGuidanceWidgetState();
}

class _PriceGuidanceWidgetState extends State<PriceGuidanceWidget> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.currentValue;
  }

  @override
  void didUpdateWidget(PriceGuidanceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != _value) {
      _value = widget.currentValue;
    }
  }

  PriceZone _getZone(double value) {
    final range = widget.maxValue - widget.minValue;
    final position = (value - widget.minValue) / range;

    if (position < 0.33) {
      return PriceZone.over;
    } else if (position < 0.67) {
      return PriceZone.target;
    } else {
      return PriceZone.low;
    }
  }

  Color _getThumbColor(PriceZone zone) {
    switch (zone) {
      case PriceZone.over:
        return Colors.red;
      case PriceZone.target:
        return Colors.green;
      case PriceZone.low:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rodistaaRed = AppColors.primaryRed;
    final currentZone = _getZone(_value);
    final thumbColor = _getThumbColor(currentZone);
    final valueColor = currentZone == PriceZone.over
        ? rodistaaRed
        : currentZone == PriceZone.target
            ? Colors.green[700]!
            : Colors.amber[700]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Value display above slider (color-coded)
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: valueColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '₹${_value.toStringAsFixed(0)}',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Slider with colored zones
        Stack(
          children: [
            // Background zones (33/34/33) - red/green/yellow
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.red,
                    Colors.green,
                    Colors.green,
                    Colors.amber,
                    Colors.amber,
                  ],
                  stops: const [0.0, 0.33, 0.33, 0.67, 0.67, 1.0],
                ),
              ),
            ),
            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: thumbColor,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                trackHeight: 8,
              ),
              child: Slider(
                value: _value,
                min: widget.minValue,
                max: widget.maxValue,
                onChanged: (newValue) {
                  setState(() {
                    _value = newValue;
                  });
                  widget.onChanged(newValue);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

enum PriceZone { over, target, low }

