import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/truck.dart';
import '../../providers/driver_provider.dart';
import '../../providers/fleet_provider.dart';
import '../../utils/formatters.dart';

// UI-level mapping: tier -> tyre count numeric values
const Map<String, int> _tierToTyre = {
  'Mini': 10,
  'LCV': 12,
  'MCV': 14,
  'HCV': 16,
  'Trailer': 18,
};

int _resolveTyreCount(Truck truck) {
  // Try to parse truckType as numeric first
  final typeStr = truck.truckType.trim();
  final numericValue = int.tryParse(typeStr);
  if (numericValue != null && numericValue > 0) {
    return numericValue;
  }
  // Map legacy tier strings to tyre counts
  return _tierToTyre[typeStr] ?? 12; // safe fallback
}

// Brand colors
const Color rodistaaRed = Color(0xFFC90D0D);
const Color softPink = Color(0xFFFCEAEA);
const Color darkRed = Color(0xFFB00A0A);

class TruckDetailsScreen extends StatelessWidget {
  const TruckDetailsScreen({super.key, required this.truckId});

  final String truckId;

  @override
  Widget build(BuildContext context) {
    final fleetProvider = context.watch<FleetProvider>();
    final driverProvider = context.watch<DriverProvider>();
    final truck = fleetProvider.trucks.firstWhere((element) => element.truckId == truckId);
    
    // Get driver phone number if driver is assigned
    String? driverPhoneNumber;
    if (truck.assignedDriverId != null) {
      try {
        final driver = driverProvider.drivers.firstWhere(
          (d) => d.driverId == truck.assignedDriverId,
        );
        driverPhoneNumber = driver.phoneNumber;
      } catch (e) {
        // Driver not found, phone number will remain null
      }
    }

    final tyreCount = _resolveTyreCount(truck);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: rodistaaRed,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          formatTruckNumber(truck.registrationNumber),
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              rodistaaRed.withValues(alpha: 0.05),
              AppColors.white,
            ],
            stops: const [0.0, 0.15],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TruckHeader(truck: truck, tyreCount: tyreCount),
              const SizedBox(height: 24),
              _InfoCard(
                title: 'Truck Info',
                icon: Icons.local_shipping,
                rows: [
                  _InfoRow(
                    label: 'RC Number',
                    value: formatTruckNumber(truck.registrationNumber),
                  ),
                  _InfoRow(
                    label: 'Tyre Count',
                    value: tyreCount.toString(),
                  ),
                  _InfoRow(
                    label: 'Registration Date',
                    value: _formatDate(truck.addedDate),
                  ),
                  _InfoRow(
                    label: 'Insurance',
                    value: _formatExpiry(truck.insuranceExpiry),
                    isExpired: truck.insuranceExpiry?.isBefore(DateTime.now()) ?? false,
                  ),
                  _InfoRow(
                    label: 'Fitness',
                    value: _formatExpiry(truck.fitnessExpiry),
                    isExpired: truck.fitnessExpiry?.isBefore(DateTime.now()) ?? false,
                  ),
                  _InfoRow(
                    label: 'Permit',
                    value: _formatExpiry(truck.permitExpiry),
                    isExpired: truck.permitExpiry?.isBefore(DateTime.now()) ?? false,
                  ),
                ],
              ),
            const SizedBox(height: 16),
              _InfoCard(
                title: 'Driver Info',
                icon: Icons.person,
                rows: [
                  _InfoRow(
                    label: 'Driver',
                    value: truck.assignedDriverName ?? 'Not assigned',
                  ),
                  if (driverPhoneNumber != null)
                    _InfoRow(
                      label: 'Phone',
                      value: driverPhoneNumber,
                    ),
                ],
                action: truck.assignedDriverId == null
                    ? ElevatedButton.icon(
                        onPressed: () => GoRouter.of(context).push('/fleet/${truck.truckId}/assign-driver'),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Assign Driver'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rodistaaRed,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_monthLabel(date.month)} ${date.year}';
  }

  static String _formatExpiry(DateTime? date) {
    if (date == null) return 'Not available';
    final expired = date.isBefore(DateTime.now());
    return expired ? 'Expired ${_formatDate(date)}' : _formatDate(date);
  }

  static String _monthLabel(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

class _TruckHeader extends StatelessWidget {
  const _TruckHeader({required this.truck, required this.tyreCount});

  final Truck truck;
  final int tyreCount;

  @override
  Widget build(BuildContext context) {
    final statusLabel = _statusLabel(truck.status);
    final statusColor = _statusColor(truck.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Truck image header
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Truck image placeholder (will show actual image when photo is added)
                // For now, show placeholder. When truck photos are added, use:
                // Image.asset(truck.photoPath, fit: BoxFit.cover, ...)
                _buildPlaceholder(),
                // Gradient overlay for better text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ),
                // Status badge and info overlay
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatTruckNumber(truck.registrationNumber),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontFamily: 'Times New Roman',
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Tyre Count: $tyreCount',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Times New Roman',
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              statusLabel,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                fontFamily: 'Times New Roman',
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceGray,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping,
              size: 80,
              color: AppColors.muteGray,
            ),
            const SizedBox(height: 12),
            Text(
              'Truck Image',
              style: TextStyle(
                color: AppColors.muteGray,
                fontSize: 14,
                fontFamily: 'Times New Roman',
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _statusColor(TruckStatus status) {
    // Only show On Trip (amber) and Idle (green)
    if (status == TruckStatus.onTrip) {
      return Colors.amber;
    }
    // Default to Idle (green) for all other statuses
    return const Color(0xFF00C853);
  }

  static String _statusLabel(TruckStatus status) {
    // Only show On Trip and Idle labels
    if (status == TruckStatus.onTrip) {
      return 'On Trip';
    }
    // Default to Idle for all other statuses
    return 'Idle';
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.rows,
    this.action,
    this.icon,
  });

  final String title;
  final List<_InfoRow> rows;
  final Widget? action;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.borderGray.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: softPink,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: rodistaaRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ],
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 20),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isExpired = false,
  });

  final String label;
  final String value;
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isExpired ? rodistaaRed : AppColors.textPrimary,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
