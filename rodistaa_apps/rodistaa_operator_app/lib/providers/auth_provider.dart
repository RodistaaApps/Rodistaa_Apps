import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const _authKey = 'is_authenticated';
  static const _mobileKey = 'mobile_number';

  bool _isAuthenticated = false;
  String? _mobileNumber;
  bool _isChecking = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get mobileNumber => _mobileNumber;
  bool get isChecking => _isChecking;

  Future<void> checkAuthStatus() async {
    if (_isChecking) return;
    _isChecking = true;
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool(_authKey) ?? false;
    _mobileNumber = prefs.getString(_mobileKey);
    _isChecking = false;
    notifyListeners();
  }

  Future<void> login(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = true;
    _mobileNumber = phoneNumber;
    await prefs.setBool(_authKey, true);
    await prefs.setString(_mobileKey, phoneNumber);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = false;
    _mobileNumber = null;
    await prefs.remove(_authKey);
    await prefs.remove(_mobileKey);
    notifyListeners();
  }
}
