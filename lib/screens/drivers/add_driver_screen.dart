import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/driver.dart';
import '../../providers/driver_provider.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String? _photoPath;
  Driver? _fetchedDriver;
  bool _isFetching = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Driver'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _photoPicker(),
              const SizedBox(height: 24),
              Text('Driver Phone Number', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: 'Enter your mobile number',
                  prefixText: '+91 ',
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (value.trim().length != 10) {
                    return 'Mobile number must be exactly 10 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'Mobile number must contain only digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isFetching ? null : _fetchDriver,
                child: _isFetching
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                    : const Text('Fetch Driver Details'),
              ),
            if (_fetchedDriver != null) ...[
              const SizedBox(height: 24),
              _DriverPreview(driver: _fetchedDriver!),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isSaving ? null : () => _saveDriver(context),
                child: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                    : const Text('Add Driver'),
              ),
            ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoPicker() {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo upload integration coming soon')),
      ),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.7)),
        ),
        child: Center(
          child: _photoPath == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.photo_camera_outlined, size: 42, color: AppColors.primaryRed),
                    const SizedBox(height: 12),
                    Text('Upload driver photo', style: AppTextStyles.body),
                    const SizedBox(height: 4),
                    Text('Camera or Gallery', style: AppTextStyles.caption),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(_photoPath!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                ),
        ),
      ),
    );
  }

  Future<void> _fetchDriver() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isFetching = true);
    await Future<void>.delayed(const Duration(seconds: 1));

    // TODO: Replace with actual Driver App API integration
    // Dummy license details for demo
    setState(() {
      _fetchedDriver = Driver(
        driverId: 'D${DateTime.now().millisecondsSinceEpoch}',
        name: 'Fetched Driver',
        phoneNumber: '+91 ${_phoneController.text.trim()}',
        licenseNumber: 'KA1234567890',
        licenseType: 'HMV',
        licenseExpiry: DateTime.now().add(const Duration(days: 365)),
        experienceYears: 5,
        status: 'unassigned',
        address: 'Synced from Driver App',
        joiningDate: DateTime.now(),
      );
      _isFetching = false;
    });
  }

  Future<void> _saveDriver(BuildContext context) async {
    if (_fetchedDriver == null) return;
    setState(() => _isSaving = true);
    final provider = context.read<DriverProvider>();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    provider.addDriver(_fetchedDriver!);
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Driver added successfully')),
    );
    Navigator.pop(context);
  }
}

class _DriverPreview extends StatelessWidget {
  const _DriverPreview({required this.driver});

  final Driver driver;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(driver.name, style: AppTextStyles.title),
            const SizedBox(height: 4),
            Text(driver.phoneNumber, style: AppTextStyles.caption),
            const SizedBox(height: 12),
            _infoRow('License', driver.licenseNumber),
            _infoRow('License Expiry', '${driver.licenseExpiry.day}/${driver.licenseExpiry.month}/${driver.licenseExpiry.year}'),
            _infoRow('Experience', '${driver.experienceYears} years'),
            _infoRow('Address', driver.address),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

