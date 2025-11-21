import 'dart:async';

import '../utils/constants.dart';

/// Mock auth service. Replace the delayed Futures with real API calls when ready.
class AuthService {
  const AuthService._();

  static Future<void> sendOtp(String mobileNumber) async {
    await Future.delayed(LoginUIConstants.sendOtpDelay);
    // TODO: Integrate with the real Send OTP API and handle errors.
  }

  static Future<void> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    await Future.delayed(LoginUIConstants.verifyOtpDelay);
    // TODO: Integrate with the real Verify OTP API and surface failures.
  }
}

