import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/bid.dart';
import '../models/booking.dart';
import 'countdown_timer.dart';

class CompactBidCardOngoing extends StatelessWidget {
  const CompactBidCardOngoing({
    super.key,
    required this.bid,
    required this.booking,
    required this.bidEndsAt,
    required this.onUpdate,
    required this.onWithdraw,
  });

  final Bid bid;
  final Booking? booking;
  final DateTime bidEndsAt;
  final VoidCallback onUpdate;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    final rodistaaRed = AppColors.primaryRed;
    const textCharcoal = Color(0xFF222222);
    const textGrey = Color(0xFF666666);
    const timerBg = Color(0xFFFFF7F7);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: LOAD #ID | Timer badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    'LOAD #${bid.bookingId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      fontFamily: 'Times New Roman',
                      color: textCharcoal,
                      letterSpacing: 0.2,
                      height: 1.2,
                    ),
                  ),
                ),
                // Timer badge - prominent
                GestureDetector(
                  onLongPress: () {
                    final fmt = bidEndsAt.toLocal().toString();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bidding ends at: $fmt')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: timerBg,
                      border: Border.all(color: rodistaaRed, width: 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: rodistaaRed.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: rodistaaRed),
                        const SizedBox(width: 4),
                        CountdownTimer(
                          endAt: bidEndsAt,
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: textCharcoal,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Second Row: Route + Category
            if (booking != null) ...[
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: rodistaaRed),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${booking!.fromCity} → ${booking!.toCity}',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: rodistaaRed,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.category_outlined, size: 16, color: textGrey),
                  const SizedBox(width: 6),
                  Text(
                    '${booking!.weight.toStringAsFixed(1)}T • ${booking!.materialType}',
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: textGrey,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            // Third Row: Your Bid | Market data (compact two-column)
            Row(
              children: [
                // Left: Your Bid
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Bid',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textGrey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${bid.bidAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: rodistaaRed,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right: Market data
                if (bid.lowestBid != null && bid.averageBid != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Market',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Low ₹${bid.lowestBid!.toStringAsFixed(0)} | Avg ₹${bid.averageBid!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textCharcoal,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Bottom Row: Update Bid + Withdraw buttons (horizontal)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rodistaaRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Update Bid',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onWithdraw,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      foregroundColor: textCharcoal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Withdraw',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
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

