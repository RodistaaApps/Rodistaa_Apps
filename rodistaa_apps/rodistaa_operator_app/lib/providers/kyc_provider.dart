import 'package:flutter/foundation.dart';
import '../models/kyc_verification.dart';
import '../services/mock_data.dart';

class KYCProvider extends ChangeNotifier {
  KYCProvider() {
    _load();
  }

  final KycService _service = KycService.instance;
  KycRecord? _record;
  bool _isLoading = true;

  KycRecord? get record => _record;
  bool get isLoading => _isLoading;

  KYCStatus get status => _record?.status ?? KYCStatus.notStarted;

  Future<void> _load() async {
    _record = await _service.fetchRecord();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendOtp(String aadhaar) async {
    _record = await _service.sendOtp(aadhaar);
    notifyListeners();
  }

  Future<bool> verifyOtp(String otp) async {
    final success = await _service.verifyOtp(otp);
    if (success) {
      _record = await _service.fetchRecord();
      notifyListeners();
    }
    return success;
  }

  Future<void> attachLicense({
    String? licenseNumber,
    bool front = false,
    bool back = false,
    String? base64Data,
  }) async {
    final data = base64Data ?? await _service.loadPlaceholderLicense();
    _record = await _service.updateDrivingLicense(
      licenseNumber: licenseNumber,
      frontBase64: front ? data : null,
      backBase64: back ? data : null,
    );
    notifyListeners();
  }

  Future<void> submitForVerification() async {
    _record = await _service.submitForVerification();
    notifyListeners();
  }
}

