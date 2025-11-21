import 'package:flutter/material.dart';

import '../constants/colors.dart';

class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.suggestedValue,
    required this.onChanged,
    this.currentValue,
  });

  final double minValue;
  final double maxValue;
  final double suggestedValue;
  final ValueChanged<double> onChanged;
  final double? currentValue;

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.currentValue ?? widget.suggestedValue;
  }

  @override
  void didUpdateWidget(PriceRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != null && widget.currentValue != _value) {
      _value = widget.currentValue!;
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

  String _getZoneLabel(PriceZone zone) {
    switch (zone) {
      case PriceZone.over:
        return 'Over-price';
      case PriceZone.target:
        return 'Target';
      case PriceZone.low:
        return 'Below-target';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentZone = _getZone(_value);
    final thumbColor = _getThumbColor(currentZone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected value display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₹${_value.toStringAsFixed(0)}',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Slider with colored zones
        Stack(
          children: [
            // Background zones
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
        // Zone labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ZoneLabel(
              label: 'Over-price',
              color: Colors.red,
              isActive: currentZone == PriceZone.over,
            ),
            _ZoneLabel(
              label: 'Target',
              color: Colors.green,
              isActive: currentZone == PriceZone.target,
            ),
            _ZoneLabel(
              label: 'Below-target',
              color: Colors.amber,
              isActive: currentZone == PriceZone.low,
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Current zone indicator
        Center(
          child: Text(
            'Current: ${_getZoneLabel(currentZone)}',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: thumbColor,
            ),
          ),
        ),
      ],
    );
  }
}

enum PriceZone { over, target, low }

class _ZoneLabel extends StatelessWidget {
  const _ZoneLabel({
    required this.label,
    required this.color,
    required this.isActive,
  });

  final String label;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isActive
                ? Border.all(color: Colors.black, width: 2)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive ? Colors.black87 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

