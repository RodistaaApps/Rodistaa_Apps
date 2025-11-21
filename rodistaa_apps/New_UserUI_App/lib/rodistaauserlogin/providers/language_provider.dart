import 'package:flutter/material.dart';

/// Provider for managing app language/locale
class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'English';
  Locale _currentLocale = const Locale('en');
  
  // Supported languages with their native representations
  final Map<String, Map<String, String>> _languages = {
    'Telugu': {'code': 'te', 'native': 'తెలుగు'},
    'English': {'code': 'en', 'native': 'English'},
    'Hindi': {'code': 'hi', 'native': 'हिन्दी'},
    'Kannada': {'code': 'kn', 'native': 'ಕನ್ನಡ'},
    'Malayalam': {'code': 'ml', 'native': 'മലയാളം'},
    'Tamil': {'code': 'ta', 'native': 'தமிழ்'},
  };
  
  String get currentLanguage => _currentLanguage;
  Locale get currentLocale => _currentLocale;
  Map<String, Map<String, String>> get languages => _languages;
  
  /// Change the app language
  void setLanguage(String language) {
    if (_languages.containsKey(language)) {
      _currentLanguage = language;
      _currentLocale = Locale(_languages[language]!['code']!);
      notifyListeners();
    }
  }
  
  /// Get translated text based on current language
  String translate(String key) {
    final translations = _getTranslations();
    return translations[_currentLanguage]?[key] ?? translations['English']![key]!;
  }
  
  /// Translation map for all supported languages
  Map<String, Map<String, String>> _getTranslations() {
    return {
      'English': {
        'tagline': 'Simplifying Indian Transport',
        'mobileNumber': 'Mobile Number',
        'sendOTP': 'Send OTP',
        'resendOTP': 'Resend OTP',
        'login': 'Login',
        'language': 'Language',
        'selectLanguage': 'Select Language',
      },
      'Telugu': {
        'tagline': 'భారతీయ రవాణాను సులభతరం చేయడం',
        'mobileNumber': 'మొబైల్ నంబర్',
        'sendOTP': 'OTP పంపండి',
        'resendOTP': 'OTP మళ్లీ పంపండి',
        'login': 'లాగిన్',
        'language': 'భాష',
        'selectLanguage': 'భాషను ఎంచుకోండి',
      },
      'Hindi': {
        'tagline': 'भारतीय परिवहन को सरल बनाना',
        'mobileNumber': 'मोबाइल नंबर',
        'sendOTP': 'OTP भेजें',
        'resendOTP': 'OTP पुनः भेजें',
        'login': 'लॉगिन',
        'language': 'भाषा',
        'selectLanguage': 'भाषा चुनें',
      },
      'Kannada': {
        'tagline': 'ಭಾರತೀಯ ಸಾರಿಗೆಯನ್ನು ಸರಳಗೊಳಿಸುವುದು',
        'mobileNumber': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ',
        'sendOTP': 'OTP ಕಳುಹಿಸಿ',
        'resendOTP': 'OTP ಮರುಕಳುಹಿಸಿ',
        'login': 'ಲಾಗಿನ್',
        'language': 'ಭಾಷೆ',
        'selectLanguage': 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
      },
      'Malayalam': {
        'tagline': 'ഇന്ത്യൻ ഗതാഗതം ലളിതമാക്കുന്നു',
        'mobileNumber': 'മൊബൈൽ നമ്പർ',
        'sendOTP': 'OTP അയയ്ക്കുക',
        'resendOTP': 'OTP വീണ്ടും അയയ്ക്കുക',
        'login': 'ലോഗിൻ',
        'language': 'ഭാഷ',
        'selectLanguage': 'ഭാഷ തിരഞ്ഞെടുക്കുക',
      },
      'Tamil': {
        'tagline': 'இந்திய போக்குவரத்தை எளிமைப்படுத்துதல்',
        'mobileNumber': 'மொபைல் எண்',
        'sendOTP': 'OTP அனுப்பு',
        'resendOTP': 'OTP மீண்டும் அனுப்பு',
        'login': 'உள்நுழைவு',
        'language': 'மொழி',
        'selectLanguage': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      },
    };
  }
}
