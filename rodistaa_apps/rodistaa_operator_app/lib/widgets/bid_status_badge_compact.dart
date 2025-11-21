import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/bid.dart';

class BidStatusBadgeCompact extends StatelessWidget {
  const BidStatusBadgeCompact({
    super.key,
    required this.status,
  });

  final BidStatus status;

  @override
  Widget build(BuildContext context) {
    final rodistaaRed = AppColors.primaryRed;

    switch (status) {
      case BidStatus.accepted:
        // Won → green filled badge
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Won',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        );
      case BidStatus.rejected:
        // Lost → red outline badge
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: rodistaaRed, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Lost',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: rodistaaRed,
            ),
          ),
        );
      case BidStatus.withdrawn:
        // Withdrawn → grey outline badge
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.grey[400]!, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Withdrawn',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        );
      case BidStatus.expired:
        return const SizedBox.shrink();
      case BidStatus.pending:
        // Should not appear in completed tab
        return const SizedBox.shrink();
    }
  }
}

