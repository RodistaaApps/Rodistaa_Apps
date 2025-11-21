import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/booking.dart';
import '../../models/truck.dart';
import '../../providers/bid_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/fleet_provider.dart';
import '../../utils/formatters.dart';
import '../../utils/truck_utils.dart';
import '../../widgets/truck_selector.dart';

// Helper function to get goods description based on material type
String _getGoodsDescription(String materialType) {
  switch (materialType.toLowerCase()) {
    case 'vegetables':
      return 'Carrots and beetroots';
    case 'pharmaceuticals':
    case 'medical':
      return 'Syringes and tablets';
    case 'groceries':
      return 'Rice, pulses, and cooking oil';
    case 'textiles':
      return 'Cotton fabric and yarn';
    case 'furniture':
      return 'Wooden chairs and tables';
    case 'electronics':
    case 'consumer electronics':
      return 'Mobile phones and laptops';
    case 'steel rods':
      return 'Steel rods and bars';
    case 'grains':
      return 'Wheat and rice bags';
    case 'fmcg goods':
      return 'Soaps, detergents, and packaged foods';
    default:
      return materialType;
  }
}

class PlaceBidScreen extends StatefulWidget {
  const PlaceBidScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  State<PlaceBidScreen> createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  DateTime? _expectedDelivery;
  String? _selectedTruckId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.read<BookingProvider>().getBookingById(widget.bookingId);
    final fleetProvider = context.watch<FleetProvider>();
    final trucks = _eligibleTrucks(fleetProvider.trucks, booking);

    if (booking == null) {
      return const Scaffold(
        body: Center(child: Text('Booking not found')),
      );
    }

    _amountController.text = _amountController.text.isEmpty
        ? booking.maxBudget.toStringAsFixed(0)
        : _amountController.text;
    _expectedDelivery ??= booking.pickupDate.add(const Duration(days: 1));

    final tyreCount = tyreCountFromLabel(booking.requiredTruckType);
    final bodyType = deriveBodyType(booking.requiredTruckType);
    final isFTL = booking.weight >= 9 || tyreCount >= 14;
    const fuelPricePerLitre = 98.0;
    const avgMileageKmPerLitre = 3.5;
    final fuelEstimate = (booking.distance / avgMileageKmPerLitre) * fuelPricePerLitre;
    final tollEstimate = booking.distance * 0.35;
    final totalEstimate = fuelEstimate + tollEstimate;

    Truck? selectedTruck;
    if (_selectedTruckId != null) {
      try {
        selectedTruck = trucks.firstWhere((t) => t.truckId == _selectedTruckId);
      } catch (_) {
        selectedTruck = null;
      }
    }

    final canSubmit = !_isSubmitting && _selectedTruckId != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Your Bid'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _section(
                title: 'Load Overview',
                child: _loadDetails(
                  booking: booking,
                  tyreCount: tyreCount,
                  bodyType: bodyType,
                  isFTL: isFTL,
                ),
              ),
              const SizedBox(height: 12),
              _section(
                title: 'Estimated Freight Charge',
                child: _costSummary(
                  fuelEstimate: fuelEstimate,
                  tollEstimate: tollEstimate,
                  totalEstimate: totalEstimate,
                ),
              ),
              const SizedBox(height: 12),
              // Your quotation
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your Quotation',
                          style: TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Times New Roman',
                        ),
                        decoration: const InputDecoration(
                          prefixText: '₹ ',
                          border: OutlineInputBorder(),
                          hintText: 'Enter your bid',
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
                      Text(
                        '💡 Suggested: ₹${(booking.minBudget + booking.maxBudget) ~/ 2}',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.darkGray,
                          fontSize: 13,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Select your truck
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Your Truck',
                          style: TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final truckId = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const TruckSelectorSheet(),
                          );
                          if (truckId != null && mounted) {
                            setState(() => _selectedTruckId = truckId);
                          }
                        },
                        icon: const Icon(Icons.local_shipping),
                        label: Builder(
                          builder: (context) {
                            if (_selectedTruckId == null) {
                              return const Text(
                                'Choose truck from MyFleet',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            if (trucks.isEmpty) {
                              return const Text(
                                'No trucks available',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            try {
                              final selected =
                                  trucks.firstWhere((t) => t.truckId == _selectedTruckId);
                              return Text(
                                'Truck: ${formatTruckNumber(selected.registrationNumber)}',
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            } catch (_) {
                              return const Text(
                                'Choose truck from MyFleet',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      if (selectedTruck != null) ...[
                        const SizedBox(height: 12),
                        _selectedTruckSummary(selectedTruck),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.w600,
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
                                color: AppColors.white,
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
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyText.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _loadDetails({
    required Booking booking,
    required int tyreCount,
    required String bodyType,
    required bool isFTL,
  }) {
    final dateFormat = DateFormat('dd MMM, h:mm a');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'LOAD #${booking.bookingId}',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: (isFTL ? AppColors.primaryRed : Colors.green).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isFTL ? 'FTL' : 'PTL',
                style: TextStyle(
                  color: isFTL ? AppColors.primaryRed : Colors.green[700],
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _detailRow('Route', '${booking.fromCity} → ${booking.toCity}'),
        const SizedBox(height: 6),
        // Goods description below location
        Text(
          _getGoodsDescription(booking.materialType),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
            fontFamily: 'Times New Roman',
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        _detailRow('Pickup time', dateFormat.format(booking.pickupDate)),
        const SizedBox(height: 6),
        _detailRow('Body type', '$bodyType body'),
        const SizedBox(height: 6),
        _detailRow('Tyre count', '$tyreCount tyres'),
        const SizedBox(height: 6),
        _detailRow(
          'Distance & Weight',
          '${booking.distance.toStringAsFixed(0)} km • ${booking.weight.toStringAsFixed(1)} tons',
        ),
        const SizedBox(height: 6),
        _detailRow(
          'Customer budget',
          '₹${booking.minBudget.toStringAsFixed(0)} - ₹${booking.maxBudget.toStringAsFixed(0)}',
        ),
      ],
    );
  }

  Widget _detailRow(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title\n',
        style: AppTextStyles.bodyText.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        children: [
          TextSpan(
            text: value,
            style: AppTextStyles.bodyText.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _costSummary({
    required double fuelEstimate,
    required double tollEstimate,
    required double totalEstimate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _costRow('Toll estimate', tollEstimate),
        const SizedBox(height: 8),
        _costRow('Estimated fuel', fuelEstimate),
        const Divider(height: 24),
        _costRow('Total (est.)', totalEstimate, highlight: true),
        const SizedBox(height: 8),
        const Text(
          'Assumes 3.5 km/l mileage & ₹98/l fuel rate',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Times New Roman',
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _costRow(String label, double amount, {bool highlight = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: highlight ? 16 : 14,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: highlight ? 18 : 14,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            color: highlight ? AppColors.primaryRed : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _selectedTruckSummary(Truck truck) {
    final tyreCount = tyreCountFromLabel(truck.truckType);
    return Container(
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
            formatTruckNumber(truck.registrationNumber),
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tyres: $tyreCount • Driver: ${truck.assignedDriverName ?? "Not assigned"}',
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<Truck> _eligibleTrucks(List<Truck> trucks, Booking? booking) {
    // Return all trucks from MyFleet for selection
    // The operator can choose any truck from their fleet
    return trucks;
  }

  Future<void> _submit(
    BuildContext context,
    Booking booking,
    List<Truck> eligibleTrucks,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTruckId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a truck to place bid')),
      );
      return;
    }

    final truck = eligibleTrucks.firstWhere((t) => t.truckId == _selectedTruckId);
    _expectedDelivery ??= booking.pickupDate.add(const Duration(days: 1));

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
          expectedDelivery: _expectedDelivery!,
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
    context.go('/bids');
  }
}

