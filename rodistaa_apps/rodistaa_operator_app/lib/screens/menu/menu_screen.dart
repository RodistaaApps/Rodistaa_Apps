import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../../models/operator_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/confirmation_dialog.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = profileProvider.profile;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _ProfileHeaderCard(
                profile: profile,
                onEdit: () => _showEditProfileSheet(context, profileProvider),
                onAvatarTap: () => _showEditProfileSheet(context, profileProvider),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Verification', icon: Icons.verified_user_outlined),
              const SizedBox(height: 12),
              _KycCard(profile: profile),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Activity', icon: Icons.assignment_outlined),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Transaction History',
                subtitle: 'View payment and promotional transactions',
                onTap: () => GoRouter.of(context).push('/profile/transactions'),
              ),
              _MenuCard(
                icon: Icons.confirmation_number_outlined,
                title: 'My Tickets',
                subtitle: 'View and manage support tickets',
                onTap: () => GoRouter.of(context).push('/profile/tickets'),
              ),
              _MenuCard(
                icon: Icons.notifications_outlined,
                title: l10n.notifications,
                subtitle: 'Stay updated with important alerts',
                onTap: () => GoRouter.of(context).push('/profile/notifications'),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Support & Tools', icon: Icons.help_outline),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.help_center_outlined,
                title: 'Help & Support',
                subtitle: 'FAQs, guides and contact support',
                onTap: () => GoRouter.of(context).push('/profile/help'),
              ),
              _MenuCard(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'Choose your preferred language',
                onTap: () => _showLanguageModal(context),
              ),
              _MenuCard(
                icon: Icons.share_outlined,
                title: 'Share App',
                subtitle: 'Invite friends and colleagues',
                onTap: () => _showShareDialog(context),
              ),
              _MenuCard(
                icon: Icons.settings_outlined,
                title: l10n.settings,
                subtitle: 'Notifications, security and more',
                onTap: () => GoRouter.of(context).push('/profile/settings'),
              ),
              _MenuCard(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: () => GoRouter.of(context).push('/profile/privacy'),
              ),
              _MenuCard(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Read our service agreement',
                onTap: () => GoRouter.of(context).push('/profile/terms'),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Account Settings', icon: Icons.manage_accounts_outlined),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.logout,
                title: l10n.logout,
                subtitle: 'Sign out from your account',
                isDestructive: true,
                onTap: () => _confirmLogout(context),
              ),
              _MenuCard(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'Permanently remove your account',
                isDestructive: true,
                onTap: () => _confirmAccountDeletion(context),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'App Version 1.0.0 • © Rodistaa',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldLogout = await ConfirmationDialog.show(
      context,
      title: l10n.logout,
      message: 'Are you sure you want to logout?',
      confirmLabel: l10n.logout,
      cancelLabel: 'Cancel',
      isDestructive: true,
      onConfirm: () {},
    );
    if (shouldLogout == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      // GoRouter redirect will handle navigation to login
    }
  }

  static Future<void> _confirmAccountDeletion(BuildContext context) async {
    final shouldDelete = await ConfirmationDialog.show(
      context,
      title: 'Delete Account',
      message: 'This action cannot be undone. Continue?',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDestructive: true,
      onConfirm: () {},
    );
    if (shouldDelete == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deletion functionality coming soon')),
      );
    }
  }
}

void _showEditProfileSheet(BuildContext context, ProfileProvider provider) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        top: 24,
      ),
      child: _EditProfileSheet(provider: provider),
    ),
  );
}

void _showLanguageModal(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const _LanguageModal(),
  );
}

Future<void> _showShareDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Share App',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Invite fellow operators and partners to Rodistaa from your contacts or favourite apps.',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Close',
              style: TextStyle(fontFamily: 'Times New Roman'),
            ),
          ),
        ],
      );
    },
  );
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.profile,
    required this.onEdit,
    required this.onAvatarTap,
  });

  final OperatorProfile profile;
  final VoidCallback onEdit;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final bool isVerified = profile.kycVerified;

    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onAvatarTap,
                  borderRadius: BorderRadius.circular(40),
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primaryRed.withValues(alpha: 0.12),
                    child: Text(
                      _initials(profile.name),
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: AppTextStyles.header.copyWith(
                          fontSize: 20,
                          color: const Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.phoneNumber,
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 14,
                          color: Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.fullAddress,
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: AppColors.primaryRed),
                  onPressed: onEdit,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isVerified ? Colors.green.withValues(alpha: 0.12) : Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(isVerified ? Icons.verified_rounded : Icons.info_outline, color: isVerified ? Colors.green : Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isVerified ? 'KYC verified' : 'KYC pending',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w700,
                            color: isVerified ? Colors.green[700] : Colors.orange[800],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isVerified
                              ? (profile.kycVerifiedDate != null
                                  ? 'Verified on ${DateFormat('dd MMM, h:mm a').format(profile.kycVerifiedDate!.toLocal())}'
                                  : 'Your Aadhaar verification is complete.')
                              : 'Complete Aadhaar OTP verification to unlock full access.',
                          style: const TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 12,
                            color: Color(0xFF4F4F4F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'R';
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryRed, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _KycCard extends StatelessWidget {
  const _KycCard({required this.profile});

  final OperatorProfile profile;

  @override
  Widget build(BuildContext context) {
    final bool isVerified = profile.kycVerified;
    final subtitle = isVerified
        ? (profile.kycVerifiedDate != null
            ? 'Verified on ${DateFormat('dd MMM, h:mm a').format(profile.kycVerifiedDate!.toLocal())}'
            : 'Your Aadhaar verification is complete.')
        : 'Complete Aadhaar OTP verification to unlock settlements and rewards.';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.credit_card, color: AppColors.primaryRed, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isVerified ? 'Aadhaar verification completed' : 'Aadhaar verification pending',
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/profile/kyc'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  isVerified ? 'View verification' : 'Complete KYC',
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red.shade600 : AppColors.primaryRed;
    final titleColor = isDestructive ? Colors.red.shade700 : const Color(0xFF1A1A1A);

    final borderRadius = BorderRadius.circular(18);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFB7B7B7)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.provider});

  final ProfileProvider provider;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.provider.profile;
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phoneNumber);
    _addressController = TextEditingController(text: profile.fullAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await widget.provider.updateProfileBasics(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Edit profile',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
              validator: (value) => value == null || value.trim().length < 10 ? 'Enter valid phone' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 2,
              validator: (value) => value == null || value.trim().isEmpty ? 'Enter address' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Save changes',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageModal extends StatelessWidget {
  const _LanguageModal();

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final currentLocale = languageProvider.currentLocale;

    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
      {'code': 'te', 'name': 'Telugu', 'flag': '🇮🇳'},
      {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳'},
      {'code': 'kn', 'name': 'Kannada', 'flag': '🇮🇳'},
      {'code': 'ml', 'name': 'Malayalam', 'flag': '🇮🇳'},
      {'code': 'ta', 'name': 'Tamil', 'flag': '🇮🇳'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Select Language',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: languages.map((lang) {
              final isSelected = currentLocale.languageCode == lang['code'];
              return GestureDetector(
                onTap: () {
                  languageProvider.changeLanguage(Locale(lang['code'] as String));
                  Navigator.pop(context);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryRed.withValues(alpha: 0.1)
                        : Colors.grey[100],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primaryRed : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang['flag'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lang['name'] as String,
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primaryRed : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(fontFamily: 'Times New Roman'),
            ),
          ),
        ],
      ),
    );
  }
}
