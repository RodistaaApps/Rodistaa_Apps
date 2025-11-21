import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/confirmation_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final settings = provider.settings;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader('Notifications'),
              SwitchListTile(
                title: const Text('Push notifications', style: TextStyle(fontFamily: 'Times New Roman')),
                subtitle: const Text('Receive booking, bid, and shipment alerts'),
                value: settings.pushNotifications,
                onChanged: provider.togglePushNotifications,
              ),
              SwitchListTile(
                title: const Text('Show nearby bookings', style: TextStyle(fontFamily: 'Times New Roman')),
                subtitle: const Text('Get alerts for loads within your radius'),
                value: settings.showNearby,
                onChanged: provider.toggleShowNearby,
              ),
              SwitchListTile(
                title: const Text('Use mobile data for maps', style: TextStyle(fontFamily: 'Times New Roman')),
                value: settings.useMobileData,
                onChanged: provider.toggleMobileData,
              ),
              const SizedBox(height: 16),
              _buildSectionHeader('Language & theme'),
              DropdownButtonFormField<String>(
                initialValue: settings.languageCode,
                decoration: const InputDecoration(labelText: 'Preferred language'),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                ],
                onChanged: provider.changeLanguage,
              ),
              const SizedBox(height: 12),
              const Text(
                'Theme',
                style: TextStyle(fontFamily: 'Times New Roman', fontWeight: FontWeight.w700),
              ),
              ...['light', 'dark', 'system'].map(
                (theme) => RadioListTile<String>(
                  value: theme,
                  groupValue: settings.theme,
                  onChanged: provider.changeTheme,
                  title: Text(
                    theme == 'light'
                        ? 'Light'
                        : theme == 'dark'
                            ? 'Dark'
                            : 'Follow system',
                    style: const TextStyle(fontFamily: 'Times New Roman'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionHeader('Account & legal'),
              _buildSettingItem(
                icon: Icons.info,
                title: 'App version',
                subtitle: '1.0.0',
              ),
              _buildSettingItem(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () => GoRouter.of(context).push('/profile/privacy'),
              ),
              _buildSettingItem(
                icon: Icons.description,
                title: 'Terms & Conditions',
                onTap: () => GoRouter.of(context).push('/profile/terms'),
              ),
              _buildSettingItem(
                icon: Icons.delete_forever,
                title: 'Delete account',
                subtitle: 'Permanently delete your account',
                onTap: () => _showDeleteAccountDialog(context),
                isDestructive: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: provider.hasPendingChanges ? provider.save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Save changes',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primaryRed, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    ConfirmationDialog.show(
      context,
      title: 'Delete Account',
      message: 'Are you sure you want to delete your account? This action cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDestructive: true,
      onConfirm: () {
        context.read<AuthProvider>().logout();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deletion requested')),
        );
      },
    );
  }
}

