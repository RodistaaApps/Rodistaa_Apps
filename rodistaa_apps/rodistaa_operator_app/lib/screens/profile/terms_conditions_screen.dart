import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last updated: December 2024',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using the Rodistaa Operator App, you accept and agree to be bound by these Terms and Conditions.',
            ),
            _buildSection(
              '2. Service Description',
              'Rodistaa provides a platform connecting operators with customers for logistics and transportation services.',
            ),
            _buildSection(
              '3. Operator Responsibilities',
              'Operators are responsible for maintaining accurate information, ensuring vehicle and driver compliance, and completing deliveries as agreed.',
            ),
            _buildSection(
              '4. Payment Terms',
              'Payments are processed after successful delivery completion. Platform commission is deducted as per agreed terms.',
            ),
            _buildSection(
              '5. Prohibited Activities',
              'Operators must not engage in fraudulent activities, provide false information, or violate any applicable laws.',
            ),
            _buildSection(
              '6. Limitation of Liability',
              'Rodistaa shall not be liable for any indirect, incidental, or consequential damages arising from the use of the platform.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('For questions about these Terms, contact us at legal@rodistaa.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

