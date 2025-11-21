import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/truck.dart';
import '../../providers/driver_provider.dart';
import '../../providers/fleet_provider.dart';
import '../../widgets/truck_card.dart';

class MyFleetScreen extends StatelessWidget {
  const MyFleetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Fleet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _popOrGoHome(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/fleet/add'),
        backgroundColor: AppColors.primaryRed,
        icon: const Icon(Icons.add),
        label: const Text('Add Truck'),
      ),
      body: SafeArea(
        child: Consumer2<FleetProvider, DriverProvider>(
          builder: (context, fleetProvider, driverProvider, _) {
            final trucks = fleetProvider.filteredTrucks;
            return Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SearchBar(provider: fleetProvider),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: trucks.isEmpty
                      ? const _EmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          itemCount: trucks.length,
                          itemBuilder: (context, index) {
                            final truck = trucks[index];
                            return TruckCard(
                              truck: truck,
                              onViewDetails: () => context.push('/fleet/${truck.truckId}'),
                              onAssignDriver: truck.assignedDriverId == null
                                  ? () => context.push('/fleet/${truck.truckId}/assign-driver')
                                  : null,
                              onChangeDriver: truck.assignedDriverId != null
                                  ? () => context.push('/fleet/${truck.truckId}/assign-driver')
                                  : null,
                              onRemoveDriver: truck.assignedDriverId != null
                                  ? () => _removeDriver(
                                        context: context,
                                        truck: truck,
                                        fleetProvider: fleetProvider,
                                        driverProvider: driverProvider,
                                      )
                                  : null,
                              onRemoveTruck: () => _confirmRemoveTruck(
                                context: context,
                                truck: truck,
                                fleetProvider: fleetProvider,
                                driverProvider: driverProvider,
                              ),
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

  void _removeDriver({
    required BuildContext context,
    required Truck truck,
    required FleetProvider fleetProvider,
    required DriverProvider driverProvider,
  }) {
    if (truck.assignedDriverId == null) return;
    fleetProvider.unassignDriver(truck.truckId, updatedStatus: TruckStatus.idle);
    driverProvider.markDriverIdle(truck.assignedDriverId!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Driver removed from truck')),
    );
  }

  void _confirmRemoveTruck({
    required BuildContext context,
    required Truck truck,
    required FleetProvider fleetProvider,
    required DriverProvider driverProvider,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Truck'),
          content: Text(
            'Are you sure you want to remove ${truck.registrationNumber}?',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                if (truck.assignedDriverId != null) {
                  driverProvider.markDriverIdle(truck.assignedDriverId!);
                }
                fleetProvider.removeTruck(truck.truckId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Truck removed successfully')),
                );
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}

void _popOrGoHome(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    context.go('/home');
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.provider});

  final FleetProvider provider;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: provider.setSearchQuery,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilterSheet(context),
        ),
        hintText: 'Search by truck number',
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderGray),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        TruckStatus? status = provider.statusFilter;
        String? tier = provider.typeFilter;
        bool? assigned = provider.assignedFilter;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: AppTextStyles.title,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            status = null;
                            tier = null;
                            assigned = null;
                          });
                          provider
                            ..setStatusFilter(null)
                            ..setTypeFilter(null)
                            ..setAssignedFilter(null);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Tyre Count', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [10, 12, 14, 16, 18].map((value) {
                      final isSelected = tier == value.toString();
                      return ChoiceChip(
                        label: Text(
                          value.toString(),
                          style: const TextStyle(fontFamily: 'Times New Roman'),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => tier = isSelected ? null : value.toString());
                          provider.setTypeFilter(tier);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Status', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [TruckStatus.idle, TruckStatus.onTrip].map((value) {
                      final isSelected = status == value;
                      return ChoiceChip(
                        label: Text(value == TruckStatus.idle ? 'Idle' : 'On Trip'),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => status = isSelected ? null : value);
                          provider.setStatusFilter(status);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Driver Assignment', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [true, false].map((value) {
                      final isSelected = assigned == value;
                      return ChoiceChip(
                        label: Text(value ? 'Assigned' : 'Not Assigned'),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => assigned = isSelected ? null : value);
                          provider.setAssignedFilter(assigned);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
          const Icon(Icons.local_shipping_outlined, size: 72, color: AppColors.muteGray),
          const SizedBox(height: 16),
          Text(
            'No trucks found',
            style: AppTextStyles.bodyText.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first truck to get started.',
            style: AppTextStyles.body.copyWith(color: AppColors.muteGray, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

