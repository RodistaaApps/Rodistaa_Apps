import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool emailNotifications = false;
  bool smsNotifications = true;
  bool pushNotifications = true;
  bool locationServices = true;
  bool autoAcceptBids = false;
  String selectedLanguage = 'English';
  String selectedCurrency = 'INR (₹)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC90D0D),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications Section
          _buildSectionHeader('Notifications', Icons.notifications_outlined),
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Enable Notifications',
            'Receive updates about your bookings',
            notificationsEnabled,
            (value) => setState(() => notificationsEnabled = value),
          ),
          _buildSwitchTile(
            'Push Notifications',
            'Get real-time alerts on your device',
            pushNotifications,
            (value) => setState(() => pushNotifications = value),
            enabled: notificationsEnabled,
          ),
          _buildSwitchTile(
            'Email Notifications',
            'Receive updates via email',
            emailNotifications,
            (value) => setState(() => emailNotifications = value),
            enabled: notificationsEnabled,
          ),
          _buildSwitchTile(
            'SMS Notifications',
            'Get text message updates',
            smsNotifications,
            (value) => setState(() => smsNotifications = value),
            enabled: notificationsEnabled,
          ),
          const SizedBox(height: 24),

          // Preferences Section
          _buildSectionHeader('Preferences', Icons.tune_outlined),
          const SizedBox(height: 12),
          _buildDropdownTile(
            'Language',
            'Choose your preferred language',
            selectedLanguage,
            ['English', 'हिंदी', 'తెలుగు', 'தமிழ்', 'ಕನ್ನಡ'],
            (value) => setState(() => selectedLanguage = value!),
          ),
          _buildDropdownTile(
            'Currency',
            'Select your currency',
            selectedCurrency,
            ['INR (₹)', 'USD (\$)', 'EUR (€)'],
            (value) => setState(() => selectedCurrency = value!),
          ),
          const SizedBox(height: 24),

          // Services Section
          _buildSectionHeader('Services', Icons.miscellaneous_services_outlined),
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Location Services',
            'Allow app to access your location',
            locationServices,
            (value) => setState(() => locationServices = value),
          ),
          _buildSwitchTile(
            'Auto-Accept Lowest Bid',
            'Automatically accept the lowest bid',
            autoAcceptBids,
            (value) => setState(() => autoAcceptBids = value),
          ),
          const SizedBox(height: 24),

          // Data & Privacy Section
          _buildSectionHeader('Data & Privacy', Icons.security_outlined),
          const SizedBox(height: 12),
          _buildActionTile(
            'Clear Cache',
            'Free up storage space',
            Icons.delete_outline,
            () => _showClearCacheDialog(),
          ),
          _buildActionTile(
            'Download My Data',
            'Export your personal data',
            Icons.download_outlined,
            () => _showComingSoon('Download Data'),
          ),
          const SizedBox(height: 40),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC90D0D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFC90D0D),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC90D0D),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged, {
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC90D0D).withOpacity(0.1)),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: enabled ? Colors.black87 : Colors.grey,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: const Color(0xFFC90D0D),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC90D0D).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFC90D0D).withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontFamily: 'Times New Roman'),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC90D0D).withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFC90D0D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFC90D0D)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '✓ Settings saved successfully!',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: Color(0xFFC90D0D),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear Cache',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'This will clear all cached data including images and temporary files. The app may take longer to load content next time.',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Times New Roman', color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Cache cleared successfully!',
                    style: TextStyle(fontFamily: 'Times New Roman'),
                  ),
                  backgroundColor: Color(0xFFC90D0D),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC90D0D),
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature coming soon!',
          style: const TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: const Color(0xFFC90D0D),
      ),
    );
  }
}

