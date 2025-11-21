/// Authentication service with mock implementation
/// 
/// In production, this would connect to real API endpoints.
/// Currently provides placeholder async methods for OTP flow.
class AuthService {
  /// Simulates sending OTP to the provided phone number
  /// 
  /// Returns true if OTP was sent successfully
  /// Delays 1 second to simulate network call
  Future<bool> sendOTP(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Basic validation
    if (phoneNumber.length != 10) {
      return false;
    }
    
    // Mock: Always succeed for valid phone numbers
    return true;
  }
  
  /// Verifies the OTP entered by user
  /// 
  /// Mock implementation: accepts "1234" as valid OTP
  /// Returns true if OTP is valid
  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock: Accept 1234 as valid OTP for any phone number
    return otp == '1234';
  }
  
  /// Resends OTP to the phone number
  /// 
  /// Returns true if resend was successful
  Future<bool> resendOTP(String phoneNumber) async {
    // Use same logic as sendOTP
    return sendOTP(phoneNumber);
  }
}
