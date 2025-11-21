import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC90D0D),
        elevation: 0,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC90D0D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: November 7, 2025',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using the Rodistaa Operator App, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use our services.',
            ),

            _buildSection(
              '2. Service Description',
              'Rodistaa provides a digital platform connecting operators with transporters and drivers for logistics and shipping services. We facilitate bookings, bidding, and tracking but do not directly provide transportation services.',
            ),

            _buildSection(
              '3. User Responsibilities',
              '• Provide accurate information during registration and booking\n• Maintain confidentiality of your account credentials\n• Comply with all applicable laws and regulations\n• Use the platform only for lawful purposes\n• Not engage in fraudulent activities or misrepresentation',
            ),

            _buildSection(
              '4. Booking and Bidding',
              '• All bookings are subject to availability and confirmation\n• Bids are binding once accepted\n• Cancellation policies apply as per the terms agreed upon\n• Payment terms must be honored\n• Operators have the right to reject bids deemed inappropriate',
            ),

            _buildSection(
              '5. Payment Terms',
              '• Payments must be made as per agreed terms\n• Transaction fees may apply\n• Refunds are subject to our refund policy\n• Disputes must be raised within 7 days of transaction\n• All prices are exclusive of applicable taxes',
            ),

            _buildSection(
              '6. Liability',
              'Rodistaa acts as an intermediary platform. We are not liable for:\n• Loss or damage to goods during transit\n• Delays caused by transporters or external factors\n• Actions of third-party service providers\n• Force majeure events',
            ),

            _buildSection(
              '7. Intellectual Property',
              'All content, trademarks, and data on this platform are the property of Rodistaa. Unauthorized use, reproduction, or distribution is prohibited.',
            ),

            _buildSection(
              '8. Privacy',
              'Your use of the app is also governed by our Privacy Policy. We collect and process your data as described in our Privacy Policy.',
            ),

            _buildSection(
              '9. Termination',
              'We reserve the right to terminate or suspend access to our services immediately, without prior notice, for conduct that we believe violates these Terms or is harmful to other users.',
            ),

            _buildSection(
              '10. Changes to Terms',
              'We reserve the right to modify these terms at any time. Continued use of the service after changes constitutes acceptance of the new terms.',
            ),

            _buildSection(
              '11. Governing Law',
              'These terms shall be governed by and construed in accordance with the laws of India. Disputes shall be subject to the exclusive jurisdiction of courts in Hyderabad, Telangana.',
            ),

            _buildSection(
              '12. Contact Us',
              'For questions about these Terms, please contact us:\n\nEmail: legal@rodistaa.com\nPhone: +91 1800-123-4567\nAddress: Rodistaa Technologies Pvt. Ltd., Hyderabad, Telangana, India',
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFC90D0D)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'By using Rodistaa, you acknowledge that you have read and understood these terms.',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        color: Color(0xFFC90D0D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

