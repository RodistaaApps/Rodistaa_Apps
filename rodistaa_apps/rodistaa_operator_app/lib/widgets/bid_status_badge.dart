import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/bid.dart';

class BidStatusBadge extends StatelessWidget {
  const BidStatusBadge({super.key, required this.status});

  final BidStatus status;

  @override
  Widget build(BuildContext context) {
    final details = _statusDetails(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: details.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: details.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        '${details.emoji} ${details.label}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: details.color,
        ),
      ),
    );
  }

  _BidStatusDetails _statusDetails(BidStatus status) {
    switch (status) {
      case BidStatus.pending:
        return const _BidStatusDetails('⏳', 'Pending', AppColors.warningOrange);
      case BidStatus.accepted:
        return const _BidStatusDetails('✅', 'Won', AppColors.primaryRed);
      case BidStatus.rejected:
        return const _BidStatusDetails('❌', 'Lost', AppColors.darkGray);
      case BidStatus.withdrawn:
        return const _BidStatusDetails('🚫', 'Withdrawn', AppColors.darkGray);
      case BidStatus.expired:
        return const _BidStatusDetails('⚠️', 'Expired', AppColors.darkGray);
    }
  }
}

class _BidStatusDetails {
  const _BidStatusDetails(this.emoji, this.label, this.color);

  final String emoji;
  final String label;
  final Color color;
}

