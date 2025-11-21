import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../providers/profile_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _showLanguageDialog(BuildContext context) async {
    final languageProvider = context.read<LanguageProvider>();
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.language),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppConstants.supportedLocales.map((locale) {
                final code = locale.languageCode;
                final isSelected = code == languageProvider.currentLocale.languageCode;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: AppColors.primaryRed,
                  ),
                  title: Text(AppConstants.localeDisplayNames[code] ?? code),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await languageProvider.changeLanguage(locale);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).closeButtonLabel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              final profile = profileProvider.profile;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.white,
                        backgroundImage: profile.profilePhotoUrl != null
                            ? NetworkImage(profile.profilePhotoUrl!)
                            : null,
                        child: profile.profilePhotoUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 48,
                                color: AppColors.primaryRed,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: AppTextStyles.header.copyWith(fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.phoneNumber,
                              style: AppTextStyles.bodyText.copyWith(
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (profile.fullAddress.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                profile.fullAddress,
                                style: AppTextStyles.bodyText.copyWith(
                                  color: AppColors.white,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          final router = GoRouter.of(context);
                          Navigator.of(context).pop();
                          Future.microtask(() {
                            router.push('/profile/edit');
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.verified_user,
                  label: 'KYC Verification',
                  onTap: () {
                    final navigator = Navigator.of(context);
                    final router = GoRouter.of(context);
                    navigator.pop();
                    router.push('/profile/kyc');
                  },
                ),
                _DrawerItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Transactions',
                  onTap: () {
                    final navigator = Navigator.of(context);
                    final router = GoRouter.of(context);
                    navigator.pop();
                    router.push('/profile/transactions');
                  },
                ),
                _DrawerItem(
                  icon: Icons.confirmation_number,
                  label: 'My Tickets',
                  onTap: () {
                    final navigator = Navigator.of(context);
                    final router = GoRouter.of(context);
                    navigator.pop();
                    router.push('/profile/tickets');
                  },
                ),
                _DrawerItem(
                  icon: Icons.notifications,
                  label: l10n.notifications,
                  onTap: () {
                    final navigator = Navigator.of(context);
                    navigator.pop();
                    Fluttertoast.showToast(msg: l10n.notifications);
                  },
                ),
                _DrawerItem(
                  icon: Icons.help_outline,
                  label: 'Help & Support',
                  onTap: () {
                    final navigator = Navigator.of(context);
                    final router = GoRouter.of(context);
                    navigator.pop();
                    router.push('/profile/help');
                  },
                ),
                _DrawerItem(
                  icon: Icons.language,
                  label: l10n.language,
                  onTap: () {
                    final navigator = Navigator.of(context);
                    navigator.pop();
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        if (!navigator.mounted) return;
                        _showLanguageDialog(navigator.context);
                      },
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings,
                  label: l10n.settings,
                  onTap: () {
                    final navigator = Navigator.of(context);
                    final router = GoRouter.of(context);
                    navigator.pop();
                    router.push('/profile/settings');
                  },
                ),
                _DrawerItem(
                  icon: Icons.logout,
                  label: l10n.logout,
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    final router = GoRouter.of(context);
                    navigator.pop();
                    await authProvider.logout();
                    Fluttertoast.showToast(msg: l10n.logout);
                    router.go('/login');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppConstants.localeDisplayNames[languageProvider.currentLocale.languageCode] ?? 'English',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryRed),
      title: Text(
        label,
        style: AppTextStyles.bodyText.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
      minLeadingWidth: 24,
      dense: true,
    );
  }
}
