import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/bid.dart';
import '../models/booking.dart';
import 'bid_status_badge_compact.dart';

class CompactBidCardCompleted extends StatelessWidget {
  const CompactBidCardCompleted({
    super.key,
    required this.bid,
    required this.booking,
    this.onViewShipment,
  });

  final Bid bid;
  final Booking? booking;
  final VoidCallback? onViewShipment;

  @override
  Widget build(BuildContext context) {
    final rodistaaRed = AppColors.primaryRed;
    const textCharcoal = Color(0xFF222222);
    const textGrey = Color(0xFF666666);

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
            // Top Row: LOAD #ID | Status Badge
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
                BidStatusBadgeCompact(status: bid.status),
              ],
            ),
            const SizedBox(height: 8),
            // Second Row: Route
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
            // Third Row: Your Bid | Market data
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
            // Bottom: View Shipment button (only if Won)
            if (bid.status == BidStatus.accepted && onViewShipment != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onViewShipment,
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
                    'View Shipment',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

