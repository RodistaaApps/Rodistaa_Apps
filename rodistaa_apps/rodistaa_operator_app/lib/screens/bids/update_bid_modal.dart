import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/bid.dart';
import '../../providers/bid_provider.dart';
import '../../widgets/confirmation_dialog.dart';

class UpdateBidModal extends StatefulWidget {
  const UpdateBidModal({super.key, required this.bidId});

  final String bidId;

  @override
  State<UpdateBidModal> createState() => _UpdateBidModalState();
}

class _UpdateBidModalState extends State<UpdateBidModal> {
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
    final rodistaaRed = AppColors.primaryRed;
    const textCharcoal = Color(0xFF333333);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Modify Bid',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 1: Top Section - Load ID, Truck, Driver
                        _infoCard(bid),
                        const SizedBox(height: 12),
                        // Card 2: Current Status
                        _statusCard(bid),
                        const SizedBox(height: 12),
                        // Card 3: New Bid Amount
                        _amountCard(),
                      ],
                    ),
                  ),
                ),
                // Bottom Buttons - sticky
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[400]!),
                            foregroundColor: textCharcoal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : () => _showUpdateConfirmation(context, bid),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: rodistaaRed,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(Bid bid) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOAD #${bid.bookingId}',
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 8),
          _infoRow(Icons.local_shipping, 'Truck', bid.truckNumber),
          const SizedBox(height: 6),
          _infoRow(Icons.person, 'Driver', bid.driverName),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
      ],
    );
  }

  Widget _statusCard(Bid bid) {
    final rodistaaRed = AppColors.primaryRed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT STATUS',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: rodistaaRed,
            ),
          ),
          const SizedBox(height: 12),
          _statusRow('Your Bid', '₹${bid.bidAmount.toStringAsFixed(0)}', highlight: true),
          const SizedBox(height: 8),
          if (bid.lowestBid != null)
            _statusRow('Lowest Bid', '₹${bid.lowestBid!.toStringAsFixed(0)}'),
          if (bid.lowestBid != null) const SizedBox(height: 8),
          if (bid.averageBid != null)
            _statusRow('Average Bid', '₹${bid.averageBid!.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _statusRow(String label, String value, {bool highlight = false}) {
    final rodistaaRed = AppColors.primaryRed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: highlight ? 16 : 14,
            fontWeight: FontWeight.w700,
            color: highlight ? rodistaaRed : const Color(0xFF222222),
          ),
        ),
      ],
    );
  }

  Widget _amountCard() {
    final rodistaaRed = AppColors.primaryRed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEW BID AMOUNT',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: rodistaaRed,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Times New Roman',
              color: rodistaaRed,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Times New Roman',
                color: rodistaaRed,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: rodistaaRed, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
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
          const Text(
            'Reduce amount to improve position',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 12,
              color: Color(0xFF666666),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateConfirmation(BuildContext context, Bid bid) {
    if (!_formKey.currentState!.validate()) return;

    final newAmount = double.parse(_amountController.text.trim());
    if (newAmount == bid.bidAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a different amount')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: 'Modify Bid',
        message: 'Modify your bid from ₹${bid.bidAmount.toStringAsFixed(0)} to ₹${newAmount.toStringAsFixed(0)}?',
        confirmLabel: 'Modify',
        onConfirm: () {
          Navigator.pop(dialogContext);
          _submit(context, bid);
        },
      ),
    );
  }

  Future<void> _submit(BuildContext context, Bid bid) async {
    if (!mounted) return;
    
    // Read provider before async operation
    final bidProvider = context.read<BidProvider>();
    final newAmount = double.parse(_amountController.text.trim());
    
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    bidProvider.updateBidAmount(
      bidId: bid.bidId,
      newAmount: newAmount,
      newRank: bid.rank > 1 ? bid.rank - 1 : 1,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    
    if (!mounted) return;
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Bid updated successfully!')),
    );
    Navigator.pop(context); // Close modal
  }
}

