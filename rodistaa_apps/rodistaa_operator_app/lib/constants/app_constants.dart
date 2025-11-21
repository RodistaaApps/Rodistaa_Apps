import 'package:flutter/material.dart';

class AppConstants {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('te'),
    Locale('ta'),
    Locale('ml'),
    Locale('hi'),
    Locale('kn'),
  ];

  static const Map<String, String> localeDisplayNames = {
    'en': 'English',
    'te': 'తెలుగు',
    'ta': 'தமிழ்',
    'ml': 'മലയാളം',
    'hi': 'हिन्दी',
    'kn': 'ಕನ್ನಡ',
  };
}
