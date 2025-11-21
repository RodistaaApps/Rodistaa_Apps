import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/driver.dart';

// Brand colors
final Color rodistaaRed = AppColors.primaryRed;
final Color pickupGreen = const Color(0xFF00C853);
final Color amber = Colors.amber;

// Map statuses to only two visible ones
String _displayStatus(String s) {
  final n = s.toLowerCase();
  if (n.contains('trip') || n.contains('ontrip') || n.contains('on trip')) {
    return 'On Trip';
  }
  return 'Available';
}

Widget _statusChip(String status) {
  final label = _displayStatus(status);
  if (label == 'On Trip') {
    return _buildChip(amber, label);
  } else {
    return _buildChip(pickupGreen, label);
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

class DriverCard extends StatelessWidget {
  const DriverCard({
    super.key,
    required this.driver,
    required this.onDetails,
    required this.onCall,
    required this.onDelete,
  });

  final Driver driver;
  final VoidCallback onDetails;
  final VoidCallback onCall;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusChip = _statusChip(driver.status);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFFCEAEA),
                  child: Icon(Icons.person, color: rodistaaRed),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        driver.phoneNumber,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Times New Roman',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status chip
                statusChip,
              ],
            ),
            const SizedBox(height: 12),
            // ACTION ROW: Details | Call | Delete (inline)
            Row(
              children: [
                // Details - outlined
                Expanded(
                  flex: 4,
                  child: OutlinedButton(
                    onPressed: onDetails,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: rodistaaRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Details',
                      style: TextStyle(
                        color: rodistaaRed,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Call - primary
                Expanded(
                  flex: 5,
                  child: ElevatedButton.icon(
                    onPressed: onCall,
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rodistaaRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Delete icon inline, accessible
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
                    icon: Icon(Icons.delete_outline, color: rodistaaRed, size: 22),
                    onPressed: onDelete,
                    tooltip: 'Remove driver',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
