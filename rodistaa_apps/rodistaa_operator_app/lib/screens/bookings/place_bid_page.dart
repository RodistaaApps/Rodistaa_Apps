import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/booking.dart';
import '../../models/truck.dart';
import '../../providers/bid_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/fleet_provider.dart';
import '../../utils/formatters.dart';
import '../../utils/preferences.dart';
import '../../utils/truck_utils.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/price_guidance_widget.dart';
import '../../widgets/truck_quick_selector.dart';

class PlaceBidPage extends StatefulWidget {
  const PlaceBidPage({
    super.key,
    required this.bookingId,
  });

  final String bookingId;

  @override
  State<PlaceBidPage> createState() => _PlaceBidPageState();
}

class _PlaceBidPageState extends State<PlaceBidPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedTruckId;
  bool _isSubmitting = false;
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferredTruck();
  }

  Future<void> _loadPreferredTruck() async {
    final preferredTruckId = await Preferences.getPreferredTruck();
    if (preferredTruckId != null && mounted) {
      final fleetProvider = context.read<FleetProvider>();
      final trucks = fleetProvider.trucks;
      final hasTruck = trucks.any((t) => t.truckId == preferredTruckId);
      if (hasTruck) {
        setState(() {
          _selectedTruckId = preferredTruckId;
        });
      }
    }
  }

  void _shareBooking(Booking booking) {
    // Share booking details
    final shareText = 'LOAD #${booking.bookingId}\n'
        'Route: ${booking.fromCity} → ${booking.toCity}\n'
        'Category: ${booking.materialType}\n'
        'Weight: ${booking.weight}T\n'
        'Distance: ${booking.distance.toStringAsFixed(0)} km';
    
    // TODO: Implement actual share functionality using share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share: $shareText'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.read<BookingProvider>().getBookingById(widget.bookingId);
    final fleetProvider = context.watch<FleetProvider>();
    final trucks = fleetProvider.trucks;

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Place Your Bid'),
        ),
        body: const Center(child: Text('Booking not found')),
      );
    }

    final tyreCount = tyreCountFromLabel(booking.requiredTruckType);
    final bodyType = deriveBodyType(booking.requiredTruckType);

    // Calculate estimates
    const fuelPricePerLitre = 98.0;
    const avgMileageKmPerLitre = 3.5;
    final fuelEstimate = (booking.distance / avgMileageKmPerLitre) * fuelPricePerLitre;
    final tollEstimate = booking.distance * 0.35;
    final totalEstimate = fuelEstimate + tollEstimate;

    // Initialize slider value if not set
    if (_sliderValue == 0) {
      final suggested = (booking.minBudget + booking.maxBudget) / 2;
      _sliderValue = suggested;
      _amountController.text = suggested.toStringAsFixed(0);
    }

    final minValue = booking.minBudget;
    final maxValue = booking.maxBudget;
    final suggestedValue = (minValue + maxValue) / 2;

    Truck? selectedTruck;
    if (_selectedTruckId != null) {
      try {
        selectedTruck = trucks.firstWhere((t) => t.truckId == _selectedTruckId);
      } catch (_) {
        selectedTruck = null;
      }
    }

    final canSubmit = !_isSubmitting && _selectedTruckId != null && _amountController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'Place Your Bid',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Text(
              'LOAD #${booking.bookingId}',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Highlighted Share button with red background
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              onPressed: () => _shareBooking(booking),
              tooltip: 'Share',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top summary card (compact)
                      _summaryCard(booking, tyreCount, bodyType),
                      const SizedBox(height: 16),
                      // Estimated charges card
                      _costSummaryCard(fuelEstimate, tollEstimate, totalEstimate),
                      const SizedBox(height: 16),
                      // Quotation + Price Guidance card (CRITICAL - same card)
                      _quotationWithGuidanceCard(
                        minValue: minValue,
                        maxValue: maxValue,
                        suggestedValue: suggestedValue,
                      ),
                      const SizedBox(height: 16),
                      // Truck selector area
                      _truckSelectorCard(trucks, selectedTruck),
                    ],
                  ),
                ),
              ),
              // Footer action row (sticky bottom)
              Container(
                padding: const EdgeInsets.all(16),
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
                          foregroundColor: const Color(0xFF222222),
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
                        onPressed: canSubmit ? () => _showPlaceBidConfirmation(context, booking, trucks) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
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
                                'Place Bid',
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
    );
  }

  Widget _summaryCard(Booking booking, int tyreCount, String bodyType) {
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
            'LOAD #${booking.bookingId}',
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${booking.fromCity} → ${booking.toCity}',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: rodistaaRed,
                  ),
                ),
              ),
              Text(
                '${booking.weight.toStringAsFixed(1)}T • $bodyType • $tyreCount tyres',
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _costSummaryCard(double fuelEstimate, double tollEstimate, double totalEstimate) {
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
            'Estimated Freight Charge',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: rodistaaRed,
            ),
          ),
          const SizedBox(height: 12),
          _costRow('Toll estimate', tollEstimate),
          const SizedBox(height: 8),
          _costRow('Estimated fuel', fuelEstimate),
          const Divider(height: 24),
          _costRow('Total (est.)', totalEstimate, highlight: true),
          const SizedBox(height: 8),
          const Text(
            'Assumes 3.5 km/l & ₹98/l',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 12,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _costRow(String label, double amount, {bool highlight = false}) {
    final rodistaaRed = AppColors.primaryRed;
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: highlight ? 16 : 13,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        const Spacer(),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: highlight ? 18 : 14,
            fontWeight: FontWeight.w700,
            color: highlight ? rodistaaRed : const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _quotationWithGuidanceCard({
    required double minValue,
    required double maxValue,
    required double suggestedValue,
  }) {
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
            'Your Quotation',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: rodistaaRed,
            ),
          ),
          const SizedBox(height: 12),
          // Numeric input field
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
              hintText: 'Enter your bid',
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              final numValue = double.tryParse(value);
              if (numValue != null && numValue >= minValue && numValue <= maxValue) {
                setState(() {
                  _sliderValue = numValue;
                });
              }
            },
            validator: (value) {
              final input = double.tryParse(value ?? '');
              if (input == null || input <= 0) {
                return 'Enter a valid amount';
              }
              return null;
            },
          ),
          // Price Guidance widget immediately below (same card)
          PriceGuidanceWidget(
            minValue: minValue,
            maxValue: maxValue,
            suggestedValue: suggestedValue,
            currentValue: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
                _amountController.text = value.toStringAsFixed(0);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _truckSelectorCard(List<Truck> trucks, Truck? selectedTruck) {
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
            'Select Your Truck',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: rodistaaRed,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final truckId = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const TruckQuickSelectorSheet(),
              );
              if (truckId != null && mounted) {
                setState(() => _selectedTruckId = truckId);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedTruckId == null
                          ? 'Select truck'
                          : 'Selected truck: ${formatTruckNumber(selectedTruck?.registrationNumber ?? '')}',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaceBidConfirmation(BuildContext context, Booking booking, List<Truck> trucks) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTruckId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a truck to place bid')),
      );
      return;
    }

    final truck = trucks.firstWhere((t) => t.truckId == _selectedTruckId);
    final bidAmount = double.parse(_amountController.text.trim());

    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: 'Confirm Bid',
        message: 'Confirm placing bid ₹${bidAmount.toStringAsFixed(0)} with truck ${formatTruckNumber(truck.registrationNumber)}?',
        confirmLabel: 'Confirm',
        onConfirm: () {
          Navigator.pop(dialogContext);
          _submit(context, booking, trucks);
        },
      ),
    );
  }

  Future<void> _submit(BuildContext context, Booking booking, List<Truck> trucks) async {
    if (!mounted) return;

    final bidProvider = context.read<BidProvider>();
    final bookingProvider = context.read<BookingProvider>();
    final truck = trucks.firstWhere((t) => t.truckId == _selectedTruckId);
    final bidAmount = double.parse(_amountController.text.trim());
    final expectedDelivery = booking.pickupDate.add(const Duration(days: 1));

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    bidProvider.placeBid(
      bookingId: booking.bookingId,
      operatorId: 'OP001',
      truckId: truck.truckId,
      truckNumber: truck.registrationNumber,
      driverId: truck.assignedDriverId ?? 'driver-${truck.truckId}',
      driverName: truck.assignedDriverName ?? 'Driver',
      amount: bidAmount,
      expectedDelivery: expectedDelivery,
      currentTotalBids: booking.totalBids,
      lowestBid: booking.minBudget,
      averageBid: (booking.minBudget + booking.maxBudget) / 2,
    );
    bookingProvider.incrementBidCount(booking.bookingId);
    bookingProvider.markBookingAsBid(booking.bookingId);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (!mounted) return;
    if (!context.mounted) return;

    final navigator = Navigator.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Bid placed successfully!')),
    );
    navigator.pop();
    if (context.mounted) {
      context.go('/bookings');
    }
  }
}

