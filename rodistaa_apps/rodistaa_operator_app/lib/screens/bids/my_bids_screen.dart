import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/bid.dart';
import '../../providers/bid_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/compact_bid_card.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/modern_bottom_nav.dart';
import 'update_bid_modal.dart';

class MyBidsScreen extends StatefulWidget {
  const MyBidsScreen({super.key});

  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bids',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          indicatorColor: AppColors.primaryRed,
          labelColor: AppColors.primaryRed,
          unselectedLabelColor: Colors.grey[600],
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            _BidList(isOngoing: true),
            _BidList(isOngoing: false),
          ],
        ),
      ),
      bottomNavigationBar: ModernBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/bookings');
              break;
            case 2:
              // Already on bids
              break;
            case 3:
              context.go('/shipments');
              break;
            case 4:
              context.push('/menu');
              break;
          }
        },
      ),
    );
  }
}

class _BidList extends StatelessWidget {
  const _BidList({required this.isOngoing});

  final bool isOngoing;

  @override
  Widget build(BuildContext context) {
    return Consumer2<BidProvider, BookingProvider>(
      builder: (context, bidProvider, bookingProvider, _) {
        final bids = isOngoing ? bidProvider.ongoingBids : bidProvider.completedBids;
        if (bids.isEmpty) {
          return _emptyState(isOngoing);
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          itemCount: bids.length,
          itemBuilder: (context, index) {
            final bid = bids[index];
            final booking = bookingProvider.getBookingById(bid.bookingId);
            
            if (isOngoing) {
              // Calculate bid end time (24 hours from booking posted date)
              final bidEndsAt = booking?.postedDate.add(const Duration(hours: 24)) ?? 
                               DateTime.now().add(const Duration(hours: 1));
              
              return CompactBidCard(
                bid: bid,
                booking: booking,
                bidEndsAt: bidEndsAt,
                onUpdate: () => _showUpdateBidModal(context, bid),
                onWithdraw: () => _showWithdrawConfirmation(
                  context,
                  bidProvider,
                  bookingProvider,
                  bid,
                ),
              );
            } else {
              return CompactBidCard(
                bid: bid,
                booking: booking,
                onViewShipment: bid.status == BidStatus.accepted
                    ? () => context.go('/shipments')
                    : null,
              );
            }
          },
        );
      },
    );
  }

  Widget _emptyState(bool ongoing) {
    final text = ongoing ? 'No ongoing bids' : 'No completed bids yet';
    final subtitle = ongoing
        ? 'Start bidding on loads to see them here.'
        : 'Your completed bids will appear here.';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_outlined, size: 72, color: AppColors.borderGray),
          const SizedBox(height: 16),
          Text(
            text,
            style: AppTextStyles.bodyText.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyles.bodyText.copyWith(color: AppColors.darkGray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showUpdateBidModal(BuildContext context, Bid bid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => UpdateBidModal(bidId: bid.bidId),
      ),
    );
  }

  void _showWithdrawConfirmation(
    BuildContext context,
    BidProvider bidProvider,
    BookingProvider bookingProvider,
    Bid bid,
  ) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Withdraw Bid',
        message: 'Are you sure you want to withdraw your bid for LOAD #${bid.bookingId}?',
        confirmLabel: 'Withdraw',
        onConfirm: () {
          bidProvider.withdrawBid(bid.bidId);
          bookingProvider.reopenBooking(bid.bookingId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bid withdrawn successfully')),
          );
        },
      ),
    );
  }
}
