import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../providers/driver_provider.dart';
import '../../widgets/driver_card.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/extended_fab.dart';
import 'driver_details_screen.dart';

class DriversListScreen extends StatelessWidget {
  const DriversListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _popOrGoHome(context),
        ),
      ),
      floatingActionButton: ExtendedFab(
        label: 'Add driver',
        onTap: () => context.push('/drivers/add'),
      ),
      body: SafeArea(
        child: Consumer<DriverProvider>(
          builder: (context, provider, _) {
            final drivers = provider.filteredDrivers;
            return Column(
              children: [
                const SizedBox(height: 16),
                _SearchAndFilter(provider: provider),
                const SizedBox(height: 16),
                Expanded(
                  child: drivers.isEmpty
                      ? const _EmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: drivers.length,
                          itemBuilder: (context, index) {
                            final driver = drivers[index];
                            return DriverCard(
                              driver: driver,
                              onDetails: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DriverDetailsScreen(
                                    driverId: driver.driverId,
                                    name: driver.name,
                                    mobile: driver.phoneNumber,
                                  ),
                                ),
                              ),
                              onCall: () => _handleCallDriver(driver.phoneNumber),
                              onDelete: () => _handleDeleteDriver(
                                context,
                                provider,
                                driver.driverId,
                                driver.name,
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

  void _handleCallDriver(String phoneNumber) {
    final uri = Uri.parse('tel:$phoneNumber');
    launchUrl(uri).catchError((error) {
      // Handle error if phone call cannot be initiated
      return false;
    });
  }

  Future<void> _handleDeleteDriver(
    BuildContext context,
    DriverProvider provider,
    String driverId,
    String driverName,
  ) async {
    // First confirmation
    final firstConfirm = await ConfirmationDialog.show(
      context,
      title: 'Delete Driver',
      message: 'Are you sure you want to delete $driverName?',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDestructive: true,
      onConfirm: () {},
    );

    if (firstConfirm != true) return;

    // Second confirmation (double confirmation)
    final secondConfirm = await ConfirmationDialog.show(
      context,
      title: 'Confirm Deletion',
      message: 'This action cannot be undone. Are you absolutely sure?',
      confirmLabel: 'Confirm Delete',
      cancelLabel: 'Cancel',
      isDestructive: true,
      onConfirm: () {},
    );

    if (secondConfirm == true && context.mounted) {
      provider.deleteDriver(driverId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$driverName has been deleted'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
    }
  }
}

void _popOrGoHome(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    context.go('/home');
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({required this.provider});

  final DriverProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            onChanged: provider.setSearchQuery,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search driver by name or number',
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.borderGray),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip('All', null),
                _filterChip('Available', 'available'),
                _filterChip('On Trip', 'ontrip'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String? value) {
    final isSelected = provider.statusFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => provider.setStatusFilter(isSelected ? null : value),
      ),
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
          const Icon(Icons.person_add_alt_1, size: 72, color: AppColors.borderGray),
          const SizedBox(height: 16),
          Text(
            'No drivers added',
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 8),
          Text(
            'Add drivers to manage assignments and trips.',
            style: AppTextStyles.body.copyWith(color: AppColors.muteGray, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

