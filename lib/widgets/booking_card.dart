import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/booking.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onPlaceBid});

  final Booking booking;
  final VoidCallback onPlaceBid;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOAD #${booking.bookingId}',
                style: AppTextStyles.bodyText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (booking.isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🆕 New',
                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.route, '${booking.fromCity} → ${booking.toCity}'),
          const SizedBox(height: 8),
          _infoRow(
            Icons.straighten,
            '${booking.distance.toStringAsFixed(0)} km  |  ⚖️ ${booking.weight.toStringAsFixed(1)} Tons',
          ),
          const SizedBox(height: 8),
          _infoRow(Icons.inventory_2_outlined, booking.materialType),
          const SizedBox(height: 16),
          _infoRow(Icons.local_shipping_outlined, 'Required: ${booking.requiredTruckType.toUpperCase()}'),
          const SizedBox(height: 8),
          _infoRow(Icons.event, 'Pickup: ${dateFormat.format(booking.pickupDate)}'),
          const SizedBox(height: 16),
          _infoRow(
            Icons.payments_outlined,
            'Budget: ₹${booking.minBudget.toStringAsFixed(0)} - ₹${booking.maxBudget.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          _infoRow(Icons.people_alt_outlined, '${booking.totalBids} operators bidding'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPlaceBid,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Place Bid',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryRed, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyText.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

