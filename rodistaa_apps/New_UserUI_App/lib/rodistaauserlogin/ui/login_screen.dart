import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'header_section.dart';
import 'login_card.dart';

/// Main login screen with header and login card
/// 
/// Displays Rodistaa branding and handles authentication flow
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC90D0D),
      body: SafeArea(
        child: Column(
          children: [
            // Red header section with logo and language selector
            const Expanded(
              flex: 4,
              child: HeaderSection(),
            ),
            
            // White login card (overlaps header slightly)
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  // White background for bottom area
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  
                  // Login card with elevation
                  Center(
                    child: LoginCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
