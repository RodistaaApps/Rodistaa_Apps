import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/bid.dart';
import '../../providers/bid_provider.dart';

class UpdateBidScreen extends StatefulWidget {
  const UpdateBidScreen({super.key, required this.bidId});

  final String bidId;

  @override
  State<UpdateBidScreen> createState() => _UpdateBidScreenState();
}

class _UpdateBidScreenState extends State<UpdateBidScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final bid = context.read<BidProvider>().getBidById(widget.bidId);
    _amountController = TextEditingController(text: bid.bidAmount.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bid = context.watch<BidProvider>().getBidById(widget.bidId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Bid'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _infoCard(bid),
            const SizedBox(height: 16),
            _statusCard(bid),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: _amountField(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : () => _submit(context, bid),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                          )
                        : const Text('Update Bid'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(Bid bid) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOAD #${bid.bookingId}',
            style: AppTextStyles.bodyText.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('Truck: ${bid.truckNumber}', style: AppTextStyles.bodyText.copyWith(fontSize: 14)),
          Text('Driver: ${bid.driverName}', style: AppTextStyles.bodyText.copyWith(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _statusCard(Bid bid) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 CURRENT STATUS',
            style: AppTextStyles.bodyText.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 12),
          _line('Your Bid', '₹${bid.bidAmount.toStringAsFixed(0)}'),
          _line('Your Rank', '#${bid.rank} of ${bid.totalBids}'),
          if (bid.lowestBid != null) _line('Lowest Bid', '₹${bid.lowestBid!.toStringAsFixed(0)}'),
          if (bid.averageBid != null)
            _line('Average Bid', '₹${bid.averageBid!.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _amountField() {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEW BID AMOUNT',
            style: AppTextStyles.bodyText.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(
              prefixText: '₹ ',
              border: OutlineInputBorder(),
              filled: true,
            ),
            validator: (value) {
              final input = double.tryParse(value ?? '');
              if (input == null || input <= 0) {
                return 'Enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          const Text('💡 Reduce amount to improve rank'),
        ],
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _line(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600)),
          Text(value, style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context, Bid bid) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    context.read<BidProvider>().updateBidAmount(
          bidId: bid.bidId,
          newAmount: double.parse(_amountController.text.trim()),
          newRank: bid.rank > 1 ? bid.rank - 1 : 1,
        );

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bid updated successfully')),
    );
    Navigator.pop(context);
  }
}

