import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/truck.dart';
import '../utils/formatters.dart';

// UI-level mapping: tier -> tyre count numeric values
const Map<String, int> _tierToTyre = {
  'Mini': 10,
  'LCV': 12,
  'MCV': 14,
  'HCV': 16,
  'Trailer': 18,
};

int _resolveTyreCount(Truck truck) {
  // Try to parse truckType as numeric first
  final typeStr = truck.truckType.trim();
  final numericValue = int.tryParse(typeStr);
  if (numericValue != null && numericValue > 0) {
    return numericValue;
  }
  // Map legacy tier strings to tyre counts
  return _tierToTyre[typeStr] ?? 12; // safe fallback
}

class TruckCard extends StatelessWidget {
  const TruckCard({
    super.key,
    required this.truck,
    required this.onViewDetails,
    this.onAssignDriver,
    this.onChangeDriver,
    this.onRemoveDriver,
    this.onRemoveTruck,
  });

  final Truck truck;
  final VoidCallback onViewDetails;
  final VoidCallback? onAssignDriver;
  final VoidCallback? onChangeDriver;
  final VoidCallback? onRemoveDriver;
  final VoidCallback? onRemoveTruck;

  bool get _hasDriver => truck.assignedDriverId != null;
  bool get _isOnTrip => truck.status == TruckStatus.onTrip;

  Widget _statusChip(TruckStatus status) {
    // Only show On Trip (amber) and Idle (green)
    if (status == TruckStatus.onTrip) {
      return _buildChip(Colors.amber, 'On Trip');
    } else {
      return _buildChip(const Color(0xFF00C853), 'Idle');
    }
  }

  Widget _buildChip(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              fontFamily: 'Times New Roman',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tyreCount = _resolveTyreCount(truck);
    final registration = formatTruckNumber(truck.registrationNumber);
    final driverName = truck.assignedDriverName ?? 'Not assigned';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: reg no + status chip
            Row(
              children: [
                Expanded(
                  child: Text(
                    registration,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
                _statusChip(truck.status),
              ],
            ),
            const SizedBox(height: 10),
            // Tyre count + driver info
            Text(
              'Tyre Count: $tyreCount',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Driver: ',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    driverName,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ACTION ROW: single horizontal row for all actions
            Row(
              children: [
                // View Details
                Expanded(
                  flex: 4,
                  child: OutlinedButton(
                    onPressed: onViewDetails,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Assign/Change Driver
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: _hasDriver
                        ? (_isOnTrip ? null : () => _showDriverOptions(context))
                        : onAssignDriver,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      _hasDriver
                          ? (_isOnTrip ? 'On Trip' : 'Change Driver')
                          : 'Assign Driver',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete icon — inline, visible, accessible
                if (onRemoveTruck != null && !_isOnTrip)
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.primaryRed,
                        size: 22,
                      ),
                      onPressed: onRemoveTruck,
                      tooltip: 'Remove truck',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDriverOptions(BuildContext context) {
    if (onChangeDriver == null && onRemoveDriver == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onChangeDriver != null)
                  ListTile(
                    leading: const Icon(Icons.swap_horiz, color: AppColors.primaryRed),
                    title: const Text('Change Driver'),
                    onTap: () {
                      Navigator.pop(context);
                      onChangeDriver?.call();
                    },
                  ),
                if (onRemoveDriver != null)
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: Colors.red),
                    title: const Text('Remove Driver'),
                    onTap: () {
                      Navigator.pop(context);
                      onRemoveDriver?.call();
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
