import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/language_provider.dart';

/// Header section with Rodistaa branding and language selector
/// 
/// Displays logo, tagline, and decorative background illustration
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFC90D0D),
      ),
      child: Stack(
        children: [
          // Background illustration (subtle truck + road pattern)
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/top_illustration.svg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback: Simple decorative pattern
                  return CustomPaint(
                    painter: _BackgroundPatternPainter(),
                  );
                },
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Language selector pill (top right)
                Align(
                  alignment: Alignment.topRight,
                  child: _LanguagePill(),
                ),
                
                const Spacer(),
                
                // Rodistaa logo (without truck icon)
                Text(
                  'Rodistaa',
                  semanticsLabel: 'Rodistaa logo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.balooBhai2(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Tagline (translated)
                Text(
                  languageProvider.translate('tagline'),
                  semanticsLabel: 'Company tagline',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Language selector pill widget (clickable)
class _LanguagePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return GestureDetector(
      onTap: () {
        _showLanguageSelector(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageProvider.translate('language'),
              semanticsLabel: 'Select language',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 16,
                color: const Color(0xFFC90D0D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Show language selection dialog
  void _showLanguageSelector(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
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
                  style: GoogleFonts.balooBhai2(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFC90D0D),
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
                        final nativeText = entry.value['native']!; // Full native name
                        final isSelected = languageProvider.currentLanguage == languageName;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: _LanguageIcon(
                            displayText: nativeText,
                            isSelected: isSelected,
                            onTap: () {
                              languageProvider.setLanguage(languageName);
                              Navigator.pop(context);
                            },
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
                        final nativeText = entry.value['native']!; // Full native name
                        final isSelected = languageProvider.currentLanguage == languageName;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: _LanguageIcon(
                            displayText: nativeText,
                            isSelected: isSelected,
                            onTap: () {
                              languageProvider.setLanguage(languageName);
                              Navigator.pop(context);
                            },
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
}

/// Individual language icon widget (circular badge style)
class _LanguageIcon extends StatelessWidget {
  final String displayText;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _LanguageIcon({
    required this.displayText,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular icon badge - RED by default, WHITE when selected
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
                  style: GoogleFonts.balooBhai2(
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFC90D0D),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter for decorative background pattern
class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // Draw curved road lines
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final y = size.height * (i * 0.2 + 0.1);
      path.moveTo(0, y);
      
      for (double x = 0; x < size.width; x += 100) {
        path.quadraticBezierTo(
          x + 50, y - 20 + (i * 5),
          x + 100, y,
        );
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Draw truck outlines
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(0.08);
    
    // Truck 1 (top right)
    final truck1 = Rect.fromLTWH(size.width - 200, 100, 80, 40);
    canvas.drawRRect(
      RRect.fromRectAndRadius(truck1, const Radius.circular(4)),
      paint,
    );
    
    // Truck 2 (middle)
    final truck2 = Rect.fromLTWH(150, size.height * 0.4, 60, 30);
    canvas.drawRRect(
      RRect.fromRectAndRadius(truck2, const Radius.circular(4)),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
