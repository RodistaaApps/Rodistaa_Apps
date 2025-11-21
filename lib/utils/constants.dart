import 'package:flutter/material.dart';

/// Shared constants for the login experience (colors, fonts, strings, sizes).
class LoginUIConstants {
  const LoginUIConstants._();

  // Colors
  static const Color brandRed = Color(0xFFC90D0D);
  static const Color cardShadow = Color(0x26000000);
  static const Color cardBackground = Colors.white;
  static const Color languageButtonText = Colors.white;
  static const Color languageButtonBorder = brandRed;
  static const Color otpHintColor = Colors.black54;

  // Fonts
  static const String brandFont = 'BalooBhai';
  static const String bodyFont = 'Times New Roman';

  // Layout / sizing
  static const double headerPhoneFraction = 0.35;
  static const double headerTabletFraction = 0.40;
  static const double cardWidthFraction = 0.92;
  static const double cardRadius = 16;
  static const double cardPadding = 20;
  static const double cardOverlap = 30;
  static const double buttonRadius = 28;
  static const double sendButtonHeight = 48;
  static const double loginButtonHeight = 52;
  static const double otpBoxSize = 48;
  static const double otpBoxSpacing = 12;

  // Typography sizes
  static const double taglineFontSize = 14;
  static const double labelFontSize = 14;
  static const double hintFontSize = 16;
  static const double infoFontSize = 12;
  static const double buttonFontSize = 16;

  // Durations
  static const Duration sendOtpDelay = Duration(seconds: 2);
  static const Duration verifyOtpDelay = Duration(seconds: 2);
  static const Duration otpCountdown = Duration(seconds: 60);

  // Assets
  /// Optional branding asset. When null we fall back to text wordmark.
  static const String? logoAsset = null;

  // Copy/text
  static const String tagline = 'Simplifying Indian Transport';
  static const String mobileLabel = 'Mobile Number';
  static const String mobileHint = 'Enter mobile number';
  static const String otpInfoText = 'We will send an OTP to verify your number.';
  static const String sendOtpText = 'Send OTP';
  static const String loginText = 'Login';
  static const String languageText = 'Language';
  static const String selectLanguageTitle = 'Select Language';
  static const String resendOtpText = 'Resend OTP';
  static const String otpErrorText = 'Enter the 4-digit OTP';
  static const String mobileErrorText = 'Enter a valid 10-digit mobile number';
  static const String otpSentMessage = 'OTP sent successfully';
  static const String otpInvalidMessage = 'Unable to verify OTP';

  // Languages
  static const List<LanguageOptionData> languages = [
    LanguageOptionData('Telugu', Locale('te')),
    LanguageOptionData('English', Locale('en')),
    LanguageOptionData('Hindi', Locale('hi')),
    LanguageOptionData('Kannada', Locale('kn')),
    LanguageOptionData('Malayalam', Locale('ml')),
    LanguageOptionData('Tamil', Locale('ta')),
  ];
}

class LanguageOptionData {
  final String label;
  final Locale locale;
  const LanguageOptionData(this.label, this.locale);
}

