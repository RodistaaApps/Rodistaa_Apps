import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'kyc_verification_screen.dart';
import 'transaction_history_screen.dart';
import 'my_tickets_screen.dart';
import 'faq_screen.dart';
import 'settings_screen.dart';
import 'terms_screen.dart';
import 'privacy_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock user data
  Map<String, String> user = {
    "name": "Rajesh Kumar",
    "phone": "+91 9876543210",
    "address": "Hyderabad, Telangana",
    "kycStatus": "Pending",
    "version": "v1.0.0",
    "aadhaarNumber": "",
    "gstNumber": "",
    "organizationName": "",
    "kycTestedAt": "",
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _loadKYCData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadKYCData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user['kycStatus'] = prefs.getString('kyc_status') ?? 'Pending';
      user['aadhaarNumber'] = prefs.getString('aadhaar_number') ?? '';
      user['gstNumber'] = prefs.getString('gst_number') ?? '';
      user['organizationName'] = prefs.getString('organization_name') ?? '';
      user['kycTestedAt'] = prefs.getString('kyc_tested_at') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              _buildProfileHeaderCard(),
              const SizedBox(height: 24),

              // KYC Verification Section
              _buildSectionHeader('KYC Verification', Icons.verified_user_outlined),
              const SizedBox(height: 12),
              _buildKYCSection(),
              const SizedBox(height: 24),

              // Transaction History Section
              _buildSectionHeader('Transaction History', Icons.account_balance_wallet_outlined),
              const SizedBox(height: 12),
              _buildPremiumListTile(
                icon: Icons.receipt_long,
                title: 'Transaction History',
                subtitle: 'View payment and promotional transactions',
                onTap: () {
                  Navigator.push(
                    context,
                    _createSlideRoute(const TransactionHistoryScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Support & Tools Section
              _buildSectionHeader('Support & Tools', Icons.help_outline),
              const SizedBox(height: 12),
              _buildPremiumListTile(
                icon: Icons.question_answer_outlined,
                title: 'Help & FAQ',
                subtitle: 'Get answers to common questions',
                onTap: () {
                  Navigator.push(
                    context,
                    _createSlideRoute(const FAQScreen()),
                  );
                },
              ),
              _buildPremiumListTile(
                icon: Icons.support_agent,
                title: 'My Tickets',
                subtitle: 'View and manage support tickets',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyTicketsScreen(),
                    ),
                  );
                },
              ),
              _buildPremiumListTile(
                icon: Icons.share,
                title: 'Share App',
                subtitle: 'Invite friends and colleagues',
                onTap: () {
                  _showShareDialog();
                },
              ),
              _buildPremiumListTile(
                icon: Icons.settings,
                title: 'Settings',
                subtitle: 'Customize your preferences',
                onTap: () {
                  Navigator.push(
                    context,
                    _createSlideRoute(const SettingsScreen()),
                  );
                },
              ),
              _buildPremiumListTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Read our terms of service',
                onTap: () {
                  Navigator.push(
                    context,
                    _createSlideRoute(const TermsScreen()),
                  );
                },
              ),
              _buildPremiumListTile(
                icon: Icons.lock_outline,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: () {
                  Navigator.push(
                    context,
                    _createSlideRoute(const PrivacyScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Account Settings Section
              _buildSectionHeader('Account Settings', Icons.manage_accounts_outlined),
              const SizedBox(height: 12),
              _buildPremiumListTile(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out from your account',
                onTap: () {
                  _showLogoutDialog();
                },
              ),
              _buildPremiumListTile(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'Permanently remove your account',
                onTap: () {
                  _showDeleteAccountDialog();
                },
              ),
              const SizedBox(height: 40),

              // Footer
              Center(
                child: Text(
                  'App Version ${user['version']} • © Rodistaa 2025',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
    final isVerified = user['kycStatus'] == 'Verified';
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC90D0D).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFC90D0D).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // Profile Avatar with Edit Icon
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFC90D0D),
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFFC90D0D).withOpacity(0.1),
                            child: Text(
                              user['name']!.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC90D0D),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user['name']!,
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showEditProfileDialog(),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFC90D0D).withOpacity(0.1),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFC90D0D),
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user['phone']!,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          user['address']!,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // KYC Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.pending_actions_outlined,
                                size: 14,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'KYC Verification Pending',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKYCSection() {
    final isVerified = user['kycStatus'] == 'Verified' && (user['kycTestedAt']?.isNotEmpty ?? false);
    
    final testedAtRaw = user['kycTestedAt'] ?? '';
    String testedLabel = 'Not tested yet';
    if (testedAtRaw.isNotEmpty) {
      try {
        final testedDate = DateTime.parse(testedAtRaw);
        testedLabel = DateFormat('dd MMM yyyy, hh:mm a').format(testedDate);
      } catch (_) {
        testedLabel = testedAtRaw;
      }
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await Navigator.push(
            context,
            _createSlideRoute(const KYCVerificationScreen()),
          );
          if (result == true) {
            _loadKYCData();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFC90D0D).withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC90D0D).withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isVerified ? Colors.green : Colors.orange).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isVerified ? Icons.verified : Icons.pending_actions_outlined,
                  color: isVerified ? Colors.green : Colors.orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVerified ? 'KYC Verified' : 'KYC Verification Pending',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isVerified ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Last tested: $testedLabel',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isVerified
                          ? 'Your documents are captured and awaiting backend confirmation.'
                          : 'Tap to finish Aadhaar and GST verification steps.',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFC90D0D)),
            ],
          ),
        ),
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
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC90D0D),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFC90D0D).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC90D0D).withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: const Color(0xFFC90D0D).withOpacity(0.1),
          highlightColor: const Color(0xFFC90D0D).withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC90D0D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: const Color(0xFFC90D0D),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: const Color(0xFFC90D0D).withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: user['name']);
    final phoneController = TextEditingController(text: user['phone']);
    final addressController = TextEditingController(text: user['address']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Color(0xFFC90D0D),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(nameController, 'Name', Icons.person),
              const SizedBox(height: 16),
              _buildDialogTextField(phoneController, 'Phone', Icons.phone),
              const SizedBox(height: 16),
              _buildDialogTextField(addressController, 'Address', Icons.location_on, maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                user['name'] = nameController.text;
                user['phone'] = phoneController.text;
                user['address'] = addressController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    '✓ Profile updated successfully!',
                    style: TextStyle(fontFamily: 'Times New Roman'),
                  ),
                  backgroundColor: const Color(0xFFC90D0D),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC90D0D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Save',
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

  Widget _buildDialogTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontFamily: 'Times New Roman'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Times New Roman', color: Color(0xFFC90D0D)),
        prefixIcon: Icon(icon, color: const Color(0xFFC90D0D)),
        filled: true,
        fillColor: const Color(0xFFC90D0D).withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout, color: Color(0xFFC90D0D), size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC90D0D),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFC90D0D), size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delete Account',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC90D0D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This action is permanent and cannot be undone. All your data will be deleted.',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Account deletion request submitted',
                            style: TextStyle(fontFamily: 'Times New Roman'),
                          ),
                          backgroundColor: const Color(0xFFC90D0D),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC90D0D),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFC90D0D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.share, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            const Text(
              'Share Rodistaa',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Color(0xFFC90D0D),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Help us grow! Share Rodistaa with your friends and colleagues.\n\n"Book trucks instantly with Rodistaa - India\'s fastest logistics platform!"\n\n📲 Download: www.rodistaa.com/app',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Share functionality coming soon!',
                      style: TextStyle(fontFamily: 'Times New Roman'),
                    ),
                    backgroundColor: const Color(0xFFC90D0D),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC90D0D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text(
                'Share Now',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}