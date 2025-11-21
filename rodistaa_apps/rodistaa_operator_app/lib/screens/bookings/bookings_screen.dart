import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../providers/booking_provider.dart';
import '../../utils/truck_utils.dart';
import '../../widgets/compact_load_card.dart';
import '../../widgets/brand_scaffold.dart';
import 'nearby_sheet.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandScaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        actions: [
          TextButton.icon(
            onPressed: () => _showNearbySheet(context),
            icon: const Icon(Icons.location_on, size: 18),
            label: const Text(
              'Nearby',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryRed,
            ),
          ),
        ],
      ),
      bottomNavIndex: 1,
      onBottomNavTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            // Already on bookings
            break;
          case 2:
            context.go('/bids');
            break;
          case 3:
            context.go('/shipments');
            break;
          case 4:
            context.push('/menu');
            break;
        }
      },
      showBanner: false,
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, provider, _) {
            final bookings = provider.availableBookings;
            if (bookings.isEmpty) {
              return const _EmptyState();
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      final tyreCount = tyreCountFromLabel(booking.requiredTruckType);
                      final bodyType = deriveBodyType(booking.requiredTruckType);
                      final isFTL = booking.weight >= 9 || tyreCount >= 14;
                      final bidEndsAt = booking.postedDate.add(const Duration(hours: 24));
                      return CompactLoadCard(
                        loadId: booking.bookingId,
                        pickup: booking.fromCity,
                        drop: booking.toCity,
                        category: booking.materialType,
                        tons: booking.weight,
                        bodyType: bodyType,
                        tyreCount: tyreCount,
                        bidEndsAt: bidEndsAt,
                        isFTL: isFTL,
                        onPlaceBid: () => _showPlaceBidPage(context, booking.bookingId),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showNearbySheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NearbySheet(),
    );
  }

  void _showPlaceBidPage(BuildContext context, String bookingId) {
    context.push('/place-bid/$bookingId');
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 72, color: AppColors.borderGray),
          const SizedBox(height: 16),
          Text(
            'No loads available right now',
            style: AppTextStyles.bodyText.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back soon for new opportunities.',
            style: AppTextStyles.bodyText.copyWith(color: AppColors.darkGray, fontSize: 14),
          ),
        ],
      ),
    );
  }
}


