import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC90D0D),
        elevation: 0,
        title: const Text(
          'Privacy Policy',
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
              'Privacy Policy',
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
              '1. Information We Collect',
              'We collect various types of information to provide and improve our services:\n\n• Personal Information: Name, phone number, email address, Aadhaar, PAN\n• Business Information: Company name, GST number, business address\n• Location Data: GPS coordinates for tracking shipments\n• Transaction Data: Payment information, booking history\n• Device Information: Device type, OS version, unique identifiers\n• Usage Data: App interactions, preferences, timestamps',
            ),

            _buildSection(
              '2. How We Use Your Information',
              'We use collected information for:\n\n• Providing and maintaining our services\n• Processing bookings and payments\n• Tracking shipments and deliveries\n• Verifying user identity (KYC)\n• Communicating updates and notifications\n• Improving user experience\n• Preventing fraud and ensuring security\n• Complying with legal obligations',
            ),

            _buildSection(
              '3. Data Sharing',
              'We may share your information with:\n\n• Transporters and Drivers: To facilitate bookings and deliveries\n• Payment Processors: To process transactions securely\n• Service Providers: Third-party vendors assisting our operations\n• Legal Authorities: When required by law or to protect our rights\n\nWe do not sell your personal information to third parties.',
            ),

            _buildSection(
              '4. Data Security',
              'We implement industry-standard security measures to protect your data:\n\n• Encryption of sensitive data in transit and at rest\n• Secure authentication mechanisms\n• Regular security audits and updates\n• Access controls and monitoring\n• Secure payment gateways\n\nHowever, no method of transmission over the internet is 100% secure.',
            ),

            _buildSection(
              '5. Location Services',
              'We collect location data to:\n\n• Track real-time shipment locations\n• Provide accurate delivery estimates\n• Optimize routes\n• Match operators with nearby transporters\n\nYou can control location permissions through your device settings, but this may limit some features.',
            ),

            _buildSection(
              '6. Cookies and Tracking',
              'We use cookies and similar technologies to:\n\n• Remember your preferences\n• Analyze app usage\n• Improve performance\n• Provide personalized experiences\n\nYou can manage cookie preferences in your device settings.',
            ),

            _buildSection(
              '7. Your Rights',
              'You have the right to:\n\n• Access your personal data\n• Correct inaccurate information\n• Request data deletion\n• Object to data processing\n• Data portability\n• Withdraw consent\n\nContact us to exercise these rights.',
            ),

            _buildSection(
              '8. Data Retention',
              'We retain your data for as long as necessary to:\n\n• Provide our services\n• Comply with legal obligations\n• Resolve disputes\n• Enforce our agreements\n\nInactive accounts may be deleted after 3 years of inactivity.',
            ),

            _buildSection(
              '9. Third-Party Links',
              'Our app may contain links to third-party websites or services. We are not responsible for their privacy practices. Please review their privacy policies.',
            ),

            _buildSection(
              '10. Children\'s Privacy',
              'Our services are not intended for users under 18 years of age. We do not knowingly collect information from children.',
            ),

            _buildSection(
              '11. Changes to Privacy Policy',
              'We may update this policy periodically. Continued use after changes constitutes acceptance. We will notify you of significant changes via email or in-app notification.',
            ),

            _buildSection(
              '12. Contact Us',
              'For privacy-related questions or requests:\n\nEmail: privacy@rodistaa.com\nPhone: +91 1800-123-4567\nData Protection Officer: dpo@rodistaa.com\n\nAddress:\nRodistaa Technologies Pvt. Ltd.\nHyderabad, Telangana, India',
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
                  Icon(Icons.security, color: Color(0xFFC90D0D)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your privacy is important to us. We are committed to protecting your personal information.',
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

