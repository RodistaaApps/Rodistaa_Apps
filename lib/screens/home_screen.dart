import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'trucking_screen.dart';
import 'freshmarts_screen.dart';
import 'warehousing_screen.dart';
import '../rodistaauserlogin/providers/language_provider.dart';

/// Home screen matching the Rodistaa design
/// Displays booking options, features, and quick actions
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header with Language Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    // Rodistaa Logo/Title (centered)
                    const Text(
                      'Rodistaa',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC90D0D),
                      ),
                    ),
                    const Spacer(),
                    // Language Selector (top right)
                    GestureDetector(
                      onTap: () => _showLanguageSelector(context, languageProvider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC90D0D),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language, color: Colors.white, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              languageProvider.translate('language'),
                              style: const TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Greeting
                Text(
                  'Hi, Rajash - let\'s move your next load!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Truck Banner Card
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.brown.shade700,
                        Colors.brown.shade500,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/banner_ad.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black26,
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Truck image placeholder
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Icon(
                          Icons.local_shipping,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      // Text content
                      Positioned(
                        left: 24,
                        top: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Book Trucks in\nSeconds',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Instant Loads • Best Rates • Cash Payments',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.95),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // NEW: Service Icons Section
                const Text(
                  'Choose Your Service',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Row of Service Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildServiceIcon(
                      context,
                      icon: Icons.local_shipping_rounded,
                      label: 'Trucking',
                      onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TruckingScreen(),
              ),
            );
                      },
                    ),
                    _buildServiceIcon(
                      context,
                      icon: Icons.shopping_basket_rounded,
                      label: 'FreshMarts',
                      onTap: () {
                        _showComingSoonDialog(context, 'FreshMarts');
                      },
                    ),
                    _buildServiceIcon(
                      context,
                      icon: Icons.warehouse_rounded,
                      label: 'Warehousing',
                      onTap: () {
                        _showComingSoonDialog(context, 'Warehousing');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Instant Payments Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFC90D0D),
                        const Color(0xFFE94949),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Background icons
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 60,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        right: 60,
                        bottom: 0,
                        child: Icon(
                          Icons.trending_up,
                          size: 50,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      // Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Instant Payments •\nDigital Bidding • Real-Time Deals',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Bid on loads. Get paid faster. 100% verified partners.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Verified Transporters Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red.shade100,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verified Transpoters • Secure\nShipments • Pan-India Network',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Rodistaa ensures every shipment reaches safely and time.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildServiceIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC90D0D),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC90D0D).withOpacity(0.28),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Icon(
              icon,
              color: Colors.white,
              size: 38,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static void _showComingSoonDialog(BuildContext context, String serviceName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                serviceName == 'FreshMarts' 
                    ? Icons.shopping_basket_outlined 
                    : Icons.warehouse_outlined,
                color: const Color(0xFFC90D0D),
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  serviceName,
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    color: Color(0xFFC90D0D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.construction_outlined,
                size: 60,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                  fontFamily: 'Times New Roman',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This service is under development and will be available soon.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: 'Times New Roman',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFC90D0D),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showLanguageSelector(BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  languageProvider.translate('selectLanguage'),
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC90D0D),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Language icons (3 per row)
                Column(
                  children: [
                    // First row (3 languages)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: languageProvider.languages.entries.take(3).map((entry) {
                        final languageName = entry.key;
                        final nativeText = entry.value['native']!;
                        final isSelected = languageProvider.currentLanguage == languageName;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: _buildLanguageIcon(
                            context,
                            languageProvider,
                            displayText: nativeText,
                            languageName: languageName,
                            isSelected: isSelected,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Second row (3 languages)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: languageProvider.languages.entries.skip(3).map((entry) {
                        final languageName = entry.key;
                        final nativeText = entry.value['native']!;
                        final isSelected = languageProvider.currentLanguage == languageName;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: _buildLanguageIcon(
                            context,
                            languageProvider,
                            displayText: nativeText,
                            languageName: languageName,
                            isSelected: isSelected,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildLanguageIcon(
    BuildContext context,
    LanguageProvider languageProvider, {
    required String displayText,
    required String languageName,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        languageProvider.setLanguage(languageName);
        Navigator.pop(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular icon badge
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white : const Color(0xFFC90D0D),
              border: Border.all(
                color: const Color(0xFFC90D0D),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  displayText,
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFFC90D0D) : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          // Selection indicator
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC90D0D),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

