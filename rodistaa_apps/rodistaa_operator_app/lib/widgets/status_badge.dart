import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.status,
  });

  final String label;
  final Color? color;
  final IconData? icon;
  final String? status;

  Color _getColor() {
    if (color != null) return color!;
    if (status != null) {
      switch (status!.toLowerCase()) {
        case 'on trip':
        case 'ontrip':
          return AppColors.amber;
        case 'idle':
          return AppColors.idleGreen;
        case 'assigned':
          return AppColors.primaryRed;
        case 'unassigned':
          return AppColors.muteGray;
        default:
          return AppColors.primaryRed;
      }
    }
    return AppColors.primaryRed;
  }

  Color _getBorderColor(Color base) {
    if (status != null && status!.toLowerCase() == 'assigned') {
      return AppColors.primaryRed;
    }
    if (status != null && status!.toLowerCase() == 'unassigned') {
      return AppColors.muteGray;
    }
    return base.withValues(alpha: 0.3);
  }

  IconData? _getIcon() {
    if (icon != null) return icon;
    if (status != null) {
      switch (status!.toLowerCase()) {
        case 'on trip':
        case 'ontrip':
          return Icons.local_shipping;
        case 'idle':
          return Icons.check_circle_outline;
        case 'assigned':
          return Icons.assignment_turned_in_outlined;
        case 'unassigned':
          return Icons.person_outline;
        default:
          return Icons.info_outline;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getColor();
    final badgeIcon = _getIcon();
    final borderColor = _getBorderColor(badgeColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeIcon != null) ...[
            Icon(badgeIcon, size: 16, color: badgeColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}

