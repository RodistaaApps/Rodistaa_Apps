import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/truck.dart';
import '../../providers/fleet_provider.dart';
import '../../utils/formatters.dart';

class AddTruckScreen extends StatefulWidget {
  const AddTruckScreen({super.key});

  @override
  State<AddTruckScreen> createState() => _AddTruckScreenState();
}

class _AddTruckScreenState extends State<AddTruckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registrationController = TextEditingController();
  int? _selectedTyreCount;
  bool _isSubmitting = false;
  String? _photoPath;

  final _tyreCounts = const [10, 12, 14, 16, 18];

  @override
  void dispose() {
    _registrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Truck'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _photoPicker(),
              const SizedBox(height: 24),
              Text(
                'RC Number',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _registrationController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'KA01AB1234',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter RC number';
                  }
                  final formatted = formatTruckNumber(value);
                  if (formatted.length < 8) {
                    return 'Enter a valid RC';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Tyre Count',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedTyreCount,
                items: _tyreCounts
                    .map((count) => DropdownMenuItem(
                          value: count,
                          child: Text(count.toString()),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTyreCount = value),
                validator: (value) => value == null ? 'Select tyre count' : null,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : () => _submit(context),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                            )
                          : const Text('Save Truck'),
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

  Widget _photoPicker() {
    return GestureDetector(
      onTap: _pickPhoto,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.6)),
        ),
        child: Center(
          child: _photoPath == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.photo_camera_outlined, size: 42, color: AppColors.primaryRed),
                    const SizedBox(height: 12),
                    Text('Tap to upload truck photo', style: AppTextStyles.body),
                    const SizedBox(height: 4),
                    Text('Camera or Gallery', style: AppTextStyles.caption),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    _photoPath!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _pickPhoto() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo capture integration coming soon')),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTyreCount == null) return;

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final formattedRc = formatTruckNumber(_registrationController.text.trim());
    final fleetProvider = context.read<FleetProvider>();

    final truck = Truck(
      truckId: 'T${DateTime.now().millisecondsSinceEpoch}',
      registrationNumber: formattedRc,
      truckType: _selectedTyreCount.toString(), // Store tyre count as string
      brand: 'Unknown',
      model: '',
      capacity: 0,
      status: TruckStatus.idle,
      addedDate: DateTime.now(),
      documents: const [],
    );

    fleetProvider.addTruck(truck);

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Truck added successfully')),
      );
      Navigator.pop(context);
    }
  }
}

