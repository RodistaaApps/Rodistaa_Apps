import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KYCVerificationScreen extends StatefulWidget {
  const KYCVerificationScreen({Key? key}) : super(key: key);

  @override
  State<KYCVerificationScreen> createState() => _KYCVerificationScreenState();
}

class _KYCVerificationScreenState extends State<KYCVerificationScreen> {
  final _aadhaarController = TextEditingController();
  final _gstController = TextEditingController();
  final _otpController = TextEditingController();

  String _kycType = 'Individual';
  String _aadhaarNumber = '';
  String _gstNumber = '';
  String _otpInput = '';
  bool _isOtpSent = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _aadhaarController.addListener(_onAadhaarChanged);
    _gstController.addListener(_onGstChanged);
    _otpController.addListener(_onOtpChanged);
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    _gstController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onAadhaarChanged() {
    final raw = _aadhaarController.text.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < raw.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += raw[i];
    }
    if (formatted != _aadhaarController.text) {
      _aadhaarController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    setState(() => _aadhaarNumber = raw);
  }

  void _onGstChanged() {
    setState(() => _gstNumber = _gstController.text.trim());
  }

  void _onOtpChanged() {
    setState(() => _otpInput = _otpController.text.trim());
  }

  bool get _isBusiness => _kycType == 'Business';
  bool get _isAadhaarValid => _aadhaarNumber.length == 12;
  bool get _canSendOtp => _isAadhaarValid && (!_isBusiness || _gstNumber.isNotEmpty);

  void _sendOtp() {
    if (!_canSendOtp) return;
    setState(() => _isOtpSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'OTP sent successfully',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: const Color(0xFFC90D0D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    if (_otpInput.length < 4) return;
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kyc_tested_at', DateTime.now().toIso8601String());
    await prefs.setString('kyc_mode_last', _kycType);

    if (!mounted) return;

    setState(() => _isVerifying = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'OTP captured. Ready for backend verification.',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: const Color(0xFFC90D0D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Color(0xFFC90D0D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFC90D0D)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Verification Type',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTypeButton('Individual')),
                const SizedBox(width: 12),
                Expanded(child: _buildTypeButton('Business')),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Aadhaar Number',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _aadhaarController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 16,
                letterSpacing: 1.0,
              ),
              decoration: _inputDecoration('Enter 12-digit Aadhaar'),
            ),
            const SizedBox(height: 20),
            if (_isBusiness) ...[
              const Text(
                'GST Number',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _gstController,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 16,
                ),
                decoration: _inputDecoration('Enter GST number'),
              ),
              const SizedBox(height: 20),
            ],
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _canSendOtp ? _sendOtp : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canSendOtp
                            ? const Color(0xFFC90D0D)
                            : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Send OTP',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:
                              _canSendOtp ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isOtpSent) ...[
              const SizedBox(height: 28),
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
                decoration: _inputDecoration('• • • • • •'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _otpInput.length >= 4 && !_isVerifying ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC90D0D),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Times New Roman',
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildTypeButton(String type) {
    final isSelected = _kycType == type;
    return InkWell(
      onTap: () {
        if (_kycType == type) return;
        setState(() {
          _kycType = type;
          _isOtpSent = false;
          _otpController.clear();
          if (!_isBusiness) {
            _gstController.clear();
            _gstNumber = '';
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC90D0D) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFC90D0D) : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC90D0D).withOpacity(isSelected ? 0.2 : 0.05),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFFC90D0D),
            ),
          ),
        ),
      ),
    );
  }
}