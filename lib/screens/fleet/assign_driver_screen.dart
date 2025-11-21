import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/driver.dart';
import '../../models/truck.dart';
import '../../providers/driver_provider.dart';
import '../../providers/fleet_provider.dart';

class AssignDriverScreen extends StatefulWidget {
  const AssignDriverScreen({
    super.key,
    required this.truckId,
  });

  final String truckId;

  @override
  State<AssignDriverScreen> createState() => _AssignDriverScreenState();
}

class _AssignDriverScreenState extends State<AssignDriverScreen> {
  String _searchQuery = '';
  String? _filterStatus; // 'available' or 'unavailable'

  @override
  Widget build(BuildContext context) {
    final fleetProvider = context.watch<FleetProvider>();
    final driverProvider = context.watch<DriverProvider>();
    final truck = fleetProvider.trucks.firstWhere((element) => element.truckId == widget.truckId);

    final allDrivers = driverProvider.filteredDrivers;
    
    // Apply filter
    var filteredDrivers = allDrivers.where((driver) {
      if (_filterStatus == null) return true;
      
      final isAvailable = _isDriverAvailable(driver);
      if (_filterStatus == 'available') {
        return isAvailable;
      } else {
        return !isAvailable;
      }
    }).toList();

    // Apply search
    final drivers = filteredDrivers.where((driver) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return driver.name.toLowerCase().contains(query) || 
             driver.phoneNumber.replaceAll(' ', '').contains(query.replaceAll(' ', ''));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Driver to ${truck.registrationNumber}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search drivers by name or number',
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.borderGray),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 12),
                // Filter buttons
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Available'),
                        selected: _filterStatus == 'available',
                        onSelected: (selected) {
                          setState(() {
                            _filterStatus = selected ? 'available' : null;
                          });
                        },
                        selectedColor: AppColors.primaryRed,
                        labelStyle: TextStyle(
                          color: _filterStatus == 'available' 
                              ? AppColors.white 
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('On Trip'),
                        selected: _filterStatus == 'unavailable',
                        onSelected: (selected) {
                          setState(() {
                            _filterStatus = selected ? 'unavailable' : null;
                          });
                        },
                        selectedColor: AppColors.primaryRed,
                        labelStyle: TextStyle(
                          color: _filterStatus == 'unavailable' 
                              ? AppColors.white 
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: drivers.isEmpty
                ? const _NoDrivers()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      final driver = drivers[index];
                      final available = _isDriverAvailable(driver);
                      return _AssignDriverTile(
                        driver: driver,
                        available: available,
                        onAssign: available
                            ? () => _assignDriver(
                                  context: context,
                                  truck: truck,
                                  driver: driver,
                                  fleetProvider: fleetProvider,
                                  driverProvider: driverProvider,
                                )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _assignDriver({
    required BuildContext context,
    required Truck truck,
    required Driver driver,
    required FleetProvider fleetProvider,
    required DriverProvider driverProvider,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Assign Driver'),
          content: Text(
            'Assign ${driver.name} to ${truck.registrationNumber}?',
            style: AppTextStyles.bodyText,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (truck.assignedDriverId != null) {
                  driverProvider.markDriverIdle(truck.assignedDriverId!);
                }
                fleetProvider.assignDriver(
                  truckId: truck.truckId,
                  driverId: driver.driverId,
                  driverName: driver.name,
                  updatedStatus: TruckStatus.onTrip,
                );
                driverProvider.assignDriverToTruck(
                  driverId: driver.driverId,
                  truckId: truck.truckId,
                  truckNumber: truck.registrationNumber,
                  truckOnTrip: true,
                );
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
                messenger.showSnackBar(
                  SnackBar(content: Text('${driver.name} assigned successfully')),
                );
              },
              child: const Text('Assign Driver'),
            ),
          ],
        );
      },
    );
  }

  bool _isDriverAvailable(Driver driver) {
    final status = driver.status.toLowerCase();
    return status == 'available' ||
        status == 'idle' ||
        status == 'unassigned';
  }
}

class _AssignDriverTile extends StatelessWidget {
  const _AssignDriverTile({
    required this.driver,
    required this.available,
    this.onAssign,
  });

  final Driver driver;
  final bool available;
  final VoidCallback? onAssign;

  @override
  Widget build(BuildContext context) {
    // Only show badge for On Trip and Available drivers
    final showBadge = available;
    final meta = showBadge ? _statusMeta(driver.status) : null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.name, style: AppTextStyles.title),
                    const SizedBox(height: 4),
                    Text(driver.phoneNumber, style: AppTextStyles.caption),
                  ],
                ),
                if (showBadge && meta != null) _StatusDot(meta: meta),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: available ? onAssign : null,
              style: FilledButton.styleFrom(
                backgroundColor: available ? AppColors.primaryRed : AppColors.borderGray,
              ),
              child: Text(available ? 'Assign Driver' : 'On Trip'),
            ),
          ],
        ),
      ),
    );
  }

  _StatusMeta _statusMeta(String status) {
    switch (status.toLowerCase()) {
      case 'ontrip':
      case 'on_trip':
        return const _StatusMeta(label: 'On Trip', color: AppColors.amber);
      case 'available':
        return const _StatusMeta(label: 'Available', color: AppColors.idleGreen);
      default:
        return const _StatusMeta(label: 'On Trip', color: AppColors.amber);
    }
  }
}

class _StatusMeta {
  const _StatusMeta({required this.label, required this.color});

  final String label;
  final Color color;
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.meta});

  final _StatusMeta meta;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: meta.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(meta.label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _NoDrivers extends StatelessWidget {
  const _NoDrivers();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off_outlined, size: 72, color: AppColors.muteGray),
          const SizedBox(height: 16),
          Text(
            'No drivers available',
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 8),
          Text(
            'Add drivers to assign them to trucks.',
            style: AppTextStyles.body.copyWith(color: AppColors.muteGray, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

