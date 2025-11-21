import 'package:flutter/material.dart';

import '../features/shipments/services/shipments_service.dart';
import '../theme.dart';

class AdvancedFilterBottomSheet extends StatefulWidget {
  const AdvancedFilterBottomSheet({
    super.key,
    required this.initialFilters,
  });

  final AdvancedShipmentFilters initialFilters;

  @override
  State<AdvancedFilterBottomSheet> createState() =>
      _AdvancedFilterBottomSheetState();
}

class _AdvancedFilterBottomSheetState extends State<AdvancedFilterBottomSheet> {
  late AdvancedShipmentFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: RodistaaTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: RodistaaTheme.gapL),
          Text('Advanced Filters', style: RodistaaTheme.headingLarge(context)),
          const SizedBox(height: RodistaaTheme.gapL),
          DropdownButtonFormField<String>(
            value: _filters.loadType,
            decoration: const InputDecoration(labelText: 'Load Type'),
            items: const [
              DropdownMenuItem(value: 'FTL', child: Text('Full Truck Load')),
              DropdownMenuItem(value: 'PTL', child: Text('Partial Truck Load')),
            ],
            onChanged: (value) => setState(() {
              _filters = _filters.copyWith(loadType: value);
            }),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Unpaid only'),
            value: _filters.unpaidOnly,
            onChanged: (value) {
              setState(() {
                _filters = _filters.copyWith(unpaidOnly: value);
              });
            },
          ),
          Slider(
            value: _filters.radiusKm ?? 50,
            min: 5,
            max: 200,
            divisions: 39,
            label: '${(_filters.radiusKm ?? 50).round()} km',
            onChanged: (value) {
              setState(() {
                _filters = _filters.copyWith(radiusKm: value);
              });
            },
          ),
          const Spacer(),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: RodistaaTheme.rodistaaRed,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => Navigator.of(context).pop(_filters),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
