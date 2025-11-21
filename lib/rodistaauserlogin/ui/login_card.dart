import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import 'otp_input.dart';

/// Main login card containing phone input and OTP verification
/// 
/// Handles the complete authentication flow
class LoginCard extends StatelessWidget {
  LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phone number input
              _PhoneNumberInput(),
              
              const SizedBox(height: 20),
              
              // Send OTP button
              _SendOTPButton(),
              
              // OTP section (only visible after OTP sent)
              if (authProvider.otpSent) ...[
                const SizedBox(height: 24),
                
                // OTP input boxes
                OTPInput(
                  onOTPComplete: (otp) {
                    authProvider.setOTP(otp);
                  },
                  onOTPChanged: (otp) {
                    authProvider.setOTP(otp);
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Timer and Resend row
                _TimerResendRow(),
                
                const SizedBox(height: 24),
                
                // Login button
                _LoginButton(),
              ],
              
              // Error message
              if (authProvider.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  authProvider.errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Phone number input field with +91 prefix
class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFC90D0D),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          // India flag icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: const Center(
              child: Text(
                '🇮🇳',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // +91 prefix
          Text(
            '+91',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Phone number field
          Expanded(
            child: Semantics(
              label: 'Enter 10-digit mobile number',
              child: TextField(
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              decoration: InputDecoration(
                hintText: languageProvider.translate('mobileNumber'),
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                counterText: '',
              ),
                onChanged: (value) {
                  authProvider.setPhoneNumber(value);
                },
                enabled: !authProvider.otpSent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Send OTP button
class _SendOTPButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: authProvider.isPhoneValid && !authProvider.otpSent && !authProvider.isSendingOTP
            ? () {
                authProvider.sendOTP();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC90D0D),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 3,
        ),
        child: authProvider.isSendingOTP
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                languageProvider.translate('sendOTP'),
                semanticsLabel: 'Send one-time password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

/// Timer and Resend OTP row
class _TimerResendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Timer
        Text(
          authProvider.formattedTimer,
          semanticsLabel: 'Time remaining: ${authProvider.formattedTimer}',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFFC90D0D),
            fontWeight: FontWeight.w600,
          ),
        ),
        
        // Resend OTP
        TextButton(
          onPressed: authProvider.isResendEnabled && !authProvider.isSendingOTP
              ? () {
                  authProvider.resendOTP();
                }
              : null,
          child: Text(
            languageProvider.translate('resendOTP'),
            semanticsLabel: 'Resend one-time password',
            style: TextStyle(
              fontSize: 16,
              color: authProvider.isResendEnabled
                  ? const Color(0xFFC90D0D)
                  : Colors.grey.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Login button
class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: authProvider.otp.length == 4 && !authProvider.isVerifying
            ? () async {
                final success = await authProvider.verifyOTP();
                if (success && context.mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC90D0D),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 3,
        ),
        child: authProvider.isVerifying
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                languageProvider.translate('login'),
                semanticsLabel: 'Login to account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
