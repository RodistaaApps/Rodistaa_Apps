import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Provider for managing authentication state and OTP flow
/// 
/// Handles phone validation, OTP sending, timer countdown, and verification
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // Phone number state
  String _phoneNumber = '';
  bool _isPhoneValid = false;
  
  // OTP state
  bool _otpSent = false;
  String _otp = '';
  int _timerSeconds = 60;
  Timer? _timer;
  bool _isResendEnabled = false;
  
  // Loading states
  bool _isSendingOTP = false;
  bool _isVerifying = false;
  
  // Error state
  String? _errorMessage;
  
  // Getters
  String get phoneNumber => _phoneNumber;
  bool get isPhoneValid => _isPhoneValid;
  bool get otpSent => _otpSent;
  String get otp => _otp;
  int get timerSeconds => _timerSeconds;
  bool get isResendEnabled => _isResendEnabled;
  bool get isSendingOTP => _isSendingOTP;
  bool get isVerifying => _isVerifying;
  String? get errorMessage => _errorMessage;
  
  /// Formats timer as MM:SS
  String get formattedTimer {
    final minutes = _timerSeconds ~/ 60;
    final seconds = _timerSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Updates phone number and validates it
  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    _isPhoneValid = _validatePhoneNumber(phone);
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Validates phone number (must be exactly 10 digits)
  bool _validatePhoneNumber(String phone) {
    return phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone);
  }
  
  /// Sends OTP and starts countdown timer
  Future<void> sendOTP() async {
    if (!_isPhoneValid || _isSendingOTP) return;
    
    _isSendingOTP = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _authService.sendOTP(_phoneNumber);
      
      if (success) {
        _otpSent = true;
        _startTimer();
      } else {
        _errorMessage = 'Failed to send OTP. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
    } finally {
      _isSendingOTP = false;
      notifyListeners();
    }
  }
  
  /// Starts 60-second countdown timer
  void _startTimer() {
    _timerSeconds = 60;
    _isResendEnabled = false;
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        _timerSeconds--;
        notifyListeners();
      } else {
        _isResendEnabled = true;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }
  
  /// Resends OTP and restarts timer
  Future<void> resendOTP() async {
    if (!_isResendEnabled || _isSendingOTP) return;
    
    _isSendingOTP = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _authService.resendOTP(_phoneNumber);
      
      if (success) {
        _otp = ''; // Clear previous OTP
        _startTimer();
      } else {
        _errorMessage = 'Failed to resend OTP. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
    } finally {
      _isSendingOTP = false;
      notifyListeners();
    }
  }
  
  /// Updates OTP value
  void setOTP(String otp) {
    _otp = otp;
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Verifies OTP and returns result
  Future<bool> verifyOTP() async {
    if (_otp.length != 4 || _isVerifying) return false;
    
    _isVerifying = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _authService.verifyOTP(_phoneNumber, _otp);
      
      if (!success) {
        _errorMessage = 'Invalid OTP. Please try again.';
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      return false;
    } finally {
      _isVerifying = false;
      notifyListeners();
    }
  }
  
  /// Resets all state
  void reset() {
    _phoneNumber = '';
    _isPhoneValid = false;
    _otpSent = false;
    _otp = '';
    _timerSeconds = 60;
    _isResendEnabled = false;
    _isSendingOTP = false;
    _isVerifying = false;
    _errorMessage = null;
    _timer?.cancel();
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
