import 'package:flutter/material.dart';
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
import '../../widgets/price_range_slider.dart';
import '../../widgets/truck_quick_selector.dart';

class PlaceBidSheet extends StatefulWidget {
  const PlaceBidSheet({
    super.key,
    required this.bookingId,
  });

  final String bookingId;

  @override
  State<PlaceBidSheet> createState() => _PlaceBidSheetState();
}

class _PlaceBidSheetState extends State<PlaceBidSheet> {
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
      return const SizedBox.shrink();
    }

    final tyreCount = tyreCountFromLabel(booking.requiredTruckType);
    final bodyType = deriveBodyType(booking.requiredTruckType);
    final isFTL = booking.weight >= 9 || tyreCount >= 14;

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

    final screenHeight = MediaQuery.of(context).size.height;
    final modalHeight = screenHeight * 0.70; // 70% of screen height
    
    return Container(
      height: modalHeight,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Compact load summary header
            _loadSummaryHeader(booking, tyreCount, bodyType, isFTL),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estimated Charges
                    _costSummaryCard(fuelEstimate, tollEstimate, totalEstimate),
                    const SizedBox(height: 16),
                    // Price Guidance Slider
                    _priceGuidanceCard(
                      minValue: minValue,
                      maxValue: maxValue,
                      suggestedValue: suggestedValue,
                    ),
                    const SizedBox(height: 16),
                    // Your Quotation
                    _quotationCard(),
                    const SizedBox(height: 16),
                    // Truck Selection
                    _truckSelectionCard(trucks, selectedTruck),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Footer actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: AppColors.primaryRed),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canSubmit ? () => _submit(context, booking, trucks) : null,
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
                              color: Colors.white,
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

  Widget _loadSummaryHeader(Booking booking, int tyreCount, String bodyType, bool isFTL) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEAEA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOAD #${booking.bookingId}',
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.fromCity} → ${booking.toCity}',
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${booking.weight.toStringAsFixed(1)}T • $bodyType • $tyreCount tyres',
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _costSummaryCard(double fuelEstimate, double tollEstimate, double totalEstimate) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estimated Freight Charge',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primaryRed,
                fontFamily: 'Times New Roman',
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
                fontSize: 12,
                fontFamily: 'Times New Roman',
                color: Color(0xFF666666),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
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

  Widget _priceGuidanceCard({
    required double minValue,
    required double maxValue,
    required double suggestedValue,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Guidance',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primaryRed,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 12),
            PriceRangeSlider(
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
      ),
    );
  }

  Widget _quotationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Quotation',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primaryRed,
                fontFamily: 'Times New Roman',
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
                color: AppColors.primaryRed,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Times New Roman',
                  color: AppColors.primaryRed,
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
                  borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
                ),
                hintText: 'Enter your bid',
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                final numValue = double.tryParse(value);
                if (numValue != null) {
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
          ],
        ),
      ),
    );
  }

  Widget _truckSelectionCard(List<Truck> trucks, Truck? selectedTruck) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Truck',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primaryRed,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
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
              icon: const Icon(Icons.local_shipping),
              label: Text(
                _selectedTruckId == null
                    ? 'Choose truck from MyFleet'
                    : 'Truck: ${formatTruckNumber(selectedTruck?.registrationNumber ?? '')}',
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            if (selectedTruck != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEAEA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatTruckNumber(selectedTruck.registrationNumber),
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tyres: ${tyreCountFromLabel(selectedTruck.truckType)} • Driver: ${selectedTruck.assignedDriverName ?? "Not assigned"}',
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, Booking booking, List<Truck> trucks) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTruckId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a truck to place bid')),
      );
      return;
    }

    final truck = trucks.firstWhere((t) => t.truckId == _selectedTruckId);
    final expectedDelivery = booking.pickupDate.add(const Duration(days: 1));

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    context.read<BidProvider>().placeBid(
          bookingId: booking.bookingId,
          operatorId: 'OP001',
          truckId: truck.truckId,
          truckNumber: truck.registrationNumber,
          driverId: truck.assignedDriverId ?? 'driver-${truck.truckId}',
          driverName: truck.assignedDriverName ?? 'Driver',
          amount: double.parse(_amountController.text.trim()),
          expectedDelivery: expectedDelivery,
          currentTotalBids: booking.totalBids,
          lowestBid: booking.minBudget,
          averageBid: (booking.minBudget + booking.maxBudget) / 2,
        );
    context.read<BookingProvider>().incrementBidCount(booking.bookingId);

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Bid placed successfully!')),
    );
    Navigator.pop(context);
  }
}

