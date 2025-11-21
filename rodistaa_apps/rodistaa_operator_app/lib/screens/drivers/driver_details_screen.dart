import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/driver.dart';
import '../../providers/driver_provider.dart';

class DriverDetailsScreen extends StatelessWidget {
  const DriverDetailsScreen({
    super.key,
    required this.driverId,
    required this.name,
    required this.mobile,
  });

  final String driverId;
  final String name;
  final String mobile;

  @override
  Widget build(BuildContext context) {
    // DEMO placeholders for Aadhaar-sourced fields
    // NOTE: This is mock/demo text ONLY. Real Aadhaar integration must be implemented
    // on backend with user consent and legal checks.

    // Get driver from provider to access license details
    final driverProvider = context.watch<DriverProvider>();
    Driver? driver;
    try {
      driver = driverProvider.drivers.firstWhere(
        (d) => d.driverId == driverId,
      );
    } catch (e) {
      driver = null;
    }

    // Demo license details (fallback if driver not found)
    final licenseNumber = driver?.licenseNumber ?? 'KA1234567890';
    final licenseType = driver?.licenseType ?? 'HMV';
    final licenseExpiry = driver?.licenseExpiry ?? DateTime.now().add(const Duration(days: 365));
    final experienceYears = driver?.experienceYears ?? 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Driver Details',
          style: TextStyle(
            color: AppColors.primaryRed,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryRed),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver name and mobile
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mobile,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 24),
            // License Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.drive_eta,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Driving License (demo)',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _keyValue('License Number', licenseNumber),
                    const SizedBox(height: 12),
                    _keyValue('License Type', licenseType),
                    const SizedBox(height: 12),
                    _keyValue(
                      'Expiry Date',
                      '${licenseExpiry.day}/${licenseExpiry.month}/${licenseExpiry.year}',
                    ),
                    const SizedBox(height: 12),
                    _keyValue('Experience', '$experienceYears years'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Government KYC Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCEAEA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            color: AppColors.primaryRed,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Government KYC (demo)',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _keyValue('Aadhaar Number', 'XXXX-XXXX-1234 (masked, demo)'),
                    const SizedBox(height: 12),
                    _keyValue('Aadhaar Verified Name', '$name (demo)'),
                    const SizedBox(height: 12),
                    _keyValue(
                      'Address (as per Aadhaar)',
                      'Demo address, City, State - 50000 (demo)',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange[700],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Note: Aadhaar/Govt integrations must be performed on backend with explicit consent, secure channels, and compliance.',
                              style: TextStyle(
                                color: Colors.orange[900],
                                fontSize: 12,
                                fontFamily: 'Times New Roman',
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
          ],
        ),
      ),
    );
  }

  Widget _keyValue(String k, String v) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            k,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              fontFamily: 'Times New Roman',
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            v,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: 'Times New Roman',
            ),
          ),
        ),
      ],
    );
  }
}

