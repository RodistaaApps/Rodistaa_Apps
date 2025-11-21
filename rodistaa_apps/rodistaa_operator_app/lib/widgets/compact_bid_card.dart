import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../models/bid.dart';
import '../models/booking.dart';
import '../providers/driver_provider.dart';
import 'bid_status_badge_compact.dart';
import 'countdown_timer.dart';
import '../utils/truck_utils.dart';

class CompactBidCard extends StatelessWidget {
  const CompactBidCard({
    super.key,
    required this.bid,
    required this.booking,
    this.bidEndsAt,
    this.onUpdate,
    this.onWithdraw,
    this.onViewShipment,
  });

  final Bid bid;
  final Booking? booking;
  final DateTime? bidEndsAt; // Only for ongoing bids
  final VoidCallback? onUpdate;
  final VoidCallback? onWithdraw;
  final VoidCallback? onViewShipment;

  bool get isOngoing => bidEndsAt != null;

  @override
  Widget build(BuildContext context) {
    final rodistaaRed = AppColors.primaryRed;
    const textCharcoal = Color(0xFF222222);
    const textGrey = Color(0xFF666666);

    // Derive body type and tyre count from booking
    String? bodyType;
    int? tyreCount;
    if (booking != null) {
      tyreCount = tyreCountFromLabel(booking!.requiredTruckType);
      bodyType = deriveBodyType(booking!.requiredTruckType);
    }

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
            // Top Row: LOAD #ID (left) | Pickup time + Timer (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                if (isOngoing && bidEndsAt != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pickup time with icon - highlighted
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 16, color: rodistaaRed),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: rodistaaRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              booking != null
                                  ? DateFormat('d MMM, hh:mm a').format(booking!.pickupDate)
                                  : 'N/A',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: rodistaaRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Timer badge
                      GestureDetector(
                        onLongPress: () {
                          final fmt = bidEndsAt!.toLocal().toString();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Bidding ends at: $fmt')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: rodistaaRed,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: rodistaaRed.withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              CountdownTimer(
                                endAt: bidEndsAt!,
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // Status badge for completed
                  BidStatusBadgeCompact(status: bid.status),
              ],
            ),
            const SizedBox(height: 10),
            // Second Row: Route (left) | Load specs (right)
            if (booking != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
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
                  ),
                  if (bodyType != null && tyreCount != null)
                    Text(
                      '${booking!.weight.toStringAsFixed(1)}T • $bodyType • $tyreCount tyres',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textGrey,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.right,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Category (left) | Description (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Category: ',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: rodistaaRed,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            booking!.materialType.isNotEmpty ? booking!.materialType : '—',
                            style: const TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking!.materialType.isNotEmpty ? booking!.materialType : '',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textGrey,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            // Your Bid (left) | Driver (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                if (isOngoing)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Driver',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Builder(
                          builder: (context) {
                            final driverProvider = context.watch<DriverProvider>();
                            final driver = driverProvider.getDriverById(bid.driverId);
                            final phoneNumber = driver?.phoneNumber ?? 'N/A';
                            return Text(
                              phoneNumber,
                              style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textCharcoal,
                              ),
                              textAlign: TextAlign.right,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            // Bottom Row: Actions
            if (isOngoing && (onUpdate != null || onWithdraw != null)) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (onUpdate != null)
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
                          'Modify Bid',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (onUpdate != null && onWithdraw != null)
                    const SizedBox(width: 10),
                  if (onWithdraw != null)
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
                          'Exit',
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
            ] else if (!isOngoing && bid.status == BidStatus.accepted && onViewShipment != null) ...[
              // View Shipment button - small, not full width
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: onViewShipment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rodistaaRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Shipment',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.white,
                      ),
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

