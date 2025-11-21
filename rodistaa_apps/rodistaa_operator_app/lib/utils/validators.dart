class Validators {
  static String? validateMobile(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Mobile number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(input)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    final input = value?.trim() ?? '';
    if (input.length != 6 || !RegExp(r'^\d{6}$').hasMatch(input)) {
      return 'Enter a valid 6-digit OTP';
    }
    return null;
  }

  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateRegistrationNumber(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Registration number is required';
    }
    if (!RegExp(r'^[A-Z]{2}-\d{2}-[A-Z]{2}-\d{4}$').hasMatch(input)) {
      return 'Enter a valid format (e.g., KA-01-AB-1234)';
    }
    return null;
  }

  static String? validateCapacity(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Capacity is required';
    }
    final parsed = double.tryParse(input);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid capacity';
    }
    return null;
  }
}
