import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class NearbySheet extends StatefulWidget {
  const NearbySheet({super.key});

  @override
  State<NearbySheet> createState() => _NearbySheetState();
}

class _NearbySheetState extends State<NearbySheet> {
  double _radius = 20.0;
  bool _isFTL = false;
  bool _isPTL = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby Bookings',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: 'Times New Roman',
                  color: Color(0xFF333333),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                color: const Color(0xFF333333),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Map Preview ABOVE search field
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                // Placeholder map
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Map preview (placeholder)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Times New Roman',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // TODO: integrate Google Maps / Mapbox view here
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Search bar below map
          TextField(
            decoration: InputDecoration(
              hintText: 'Search location or area',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF777777)),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          // FTL / PTL Toggle - Two-pill segmented control
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text(
                    'FTL',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: _isFTL,
                  onSelected: (selected) {
                    setState(() {
                      _isFTL = selected;
                      if (selected) _isPTL = false;
                    });
                  },
                  selectedColor: AppColors.primaryRed,
                  labelStyle: TextStyle(
                    color: _isFTL ? Colors.white : const Color(0xFF333333),
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w600,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: const Text(
                    'PTL',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: _isPTL,
                  onSelected: (selected) {
                    setState(() {
                      _isPTL = selected;
                      if (selected) _isFTL = false;
                    });
                  },
                  selectedColor: AppColors.primaryRed,
                  labelStyle: TextStyle(
                    color: _isPTL ? Colors.white : const Color(0xFF333333),
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w600,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Radius Slider - compact, minimal
          Row(
            children: [
              const Text(
                'Radius',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: _radius,
                  min: 0,
                  max: 20,
                  divisions: 20,
                  onChanged: (v) => setState(() => _radius = v),
                  activeColor: AppColors.primaryRed,
                ),
              ),
              Text(
                '${_radius.toStringAsFixed(0)} km',
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Apply Filters CTA - Rodistaa Red, wide and prominent
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
