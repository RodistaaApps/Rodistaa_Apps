import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class FilterLoadsSheet extends StatefulWidget {
  const FilterLoadsSheet({super.key});

  @override
  State<FilterLoadsSheet> createState() => _FilterLoadsSheetState();
}

class _FilterLoadsSheetState extends State<FilterLoadsSheet> {
  bool _isFTL = false;
  bool _isPTL = false;
  bool _showNearby = false;
  double _radius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEAEA),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Loads',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: 'Times New Roman',
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isFTL = false;
                    _isPTL = false;
                    _showNearby = false;
                    _radius = 20.0;
                  });
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Search bar
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search route or load id',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              // Search functionality can be implemented here
            },
          ),
          const SizedBox(height: 12),
          // Map placeholder
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
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
          ),
          const SizedBox(height: 12),
          // Full/Partial toggle
          Row(
            children: [
              ChoiceChip(
                label: const Text('FTL'),
                selected: _isFTL,
                onSelected: (selected) {
                  setState(() {
                    _isFTL = selected;
                    if (selected) _isPTL = false;
                  });
                },
                selectedColor: AppColors.primaryRed,
                labelStyle: TextStyle(
                  color: _isFTL ? Colors.white : AppColors.textPrimary,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('PTL'),
                selected: _isPTL,
                onSelected: (selected) {
                  setState(() {
                    _isPTL = selected;
                    if (selected) _isFTL = false;
                  });
                },
                selectedColor: AppColors.primaryRed,
                labelStyle: TextStyle(
                  color: _isPTL ? Colors.white : AppColors.textPrimary,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _showNearby = !_showNearby);
                  },
                  icon: Icon(_showNearby ? Icons.location_on : Icons.location_off),
                  label: const Text('Show nearby'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showNearby ? AppColors.primaryRed : Colors.grey[300],
                    foregroundColor: _showNearby ? Colors.white : Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Radius slider (mock)
          Row(
            children: [
              const Text(
                'Radius (km)',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 13,
                ),
              ),
              Expanded(
                child: Slider(
                  value: _radius,
                  min: 5,
                  max: 200,
                  divisions: 39,
                  onChanged: (v) => setState(() => _radius = v),
                  activeColor: AppColors.primaryRed,
                ),
              ),
              Text(
                '${_radius.toStringAsFixed(0)}km',
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w700,
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

