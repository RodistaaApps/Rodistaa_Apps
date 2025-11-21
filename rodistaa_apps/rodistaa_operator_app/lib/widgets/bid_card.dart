import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/bid.dart';
import '../models/booking.dart';
import 'bid_status_badge.dart';

class BidCard extends StatelessWidget {
  const BidCard({
    super.key,
    required this.bid,
    required this.booking,
    this.onUpdate,
    this.onWithdraw,
    this.onViewDetails,
    this.primaryActionLabel,
    this.onPrimaryAction,
  });

  final Bid bid;
  final Booking? booking;
  final VoidCallback? onUpdate;
  final VoidCallback? onWithdraw;
  final VoidCallback? onViewDetails;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, h:mm a');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LOAD #${bid.bookingId}',
                style: AppTextStyles.bodyText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              BidStatusBadge(status: bid.status),
            ],
          ),
          const SizedBox(height: 12),
          if (booking != null) ...[
            _info('📍 Route', '${booking!.fromCity} → ${booking!.toCity}'),
            const SizedBox(height: 6),
            _info('⚖️ Load', '${booking!.weight.toStringAsFixed(1)} Tons | ${booking!.materialType}'),
            const SizedBox(height: 6),
          ],
          _info('💰 Your Bid', '₹${bid.bidAmount.toStringAsFixed(0)}'),
          const SizedBox(height: 6),
          _info('🏆 Rank', '#${bid.rank} of ${bid.totalBids}'),
          const SizedBox(height: 6),
          _info('📅 Placed', dateFormat.format(bid.bidPlacedAt)),
          if (bid.lowestBid != null && bid.averageBid != null) ...[
            const SizedBox(height: 6),
            _info(
              '📊 Market',
              'Lowest ₹${bid.lowestBid!.toStringAsFixed(0)} | Avg ₹${bid.averageBid!.toStringAsFixed(0)}',
            ),
          ],
          if (bid.rejectionReason != null && bid.rejectionReason!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Reason: ${bid.rejectionReason}',
              style: AppTextStyles.bodyText.copyWith(
                fontSize: 13,
                color: AppColors.darkGray,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (onUpdate != null && bid.status == BidStatus.pending)
                _chipButton(label: 'Update Bid', onPressed: onUpdate!),
              if (onWithdraw != null && bid.status == BidStatus.pending)
                _chipButton(
                  label: 'Withdraw',
                  onPressed: onWithdraw!,
                  background: AppColors.lightGray,
                  textColor: AppColors.darkGray,
                ),
              if (onViewDetails != null)
                _chipButton(
                  label: 'View Details',
                  onPressed: onViewDetails!,
                  background: AppColors.lightGray,
                  textColor: AppColors.primaryRed,
                ),
              if (primaryActionLabel != null && onPrimaryAction != null)
                _chipButton(
                  label: primaryActionLabel!,
                  onPressed: onPrimaryAction!,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: AppTextStyles.bodyText.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        children: [
          TextSpan(
            text: value,
            style: AppTextStyles.bodyText.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipButton({
    required String label,
    required VoidCallback onPressed,
    Color background = AppColors.primaryRed,
    Color textColor = AppColors.white,
  }) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

