import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/kyc_verification.dart';
import '../../providers/kyc_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/mock_data.dart';
import '../../widgets/otp_input.dart';

class KYCVerificationScreen extends StatefulWidget {
  const KYCVerificationScreen({super.key});

  @override
  State<KYCVerificationScreen> createState() => _KYCVerificationScreenState();
}

class _KYCVerificationScreenState extends State<KYCVerificationScreen> {
  final TextEditingController _aadhaarController = TextEditingController();

  bool _sendingOtp = false;
  bool _verifyingOtp = false;
  bool _hydrated = false;
  bool _otpVisible = false;
  int _secondsLeft = 0;
  String? _aadhaarError;
  String? _otpError;
  String _otpValue = '';
  Timer? _otpTimer;
  Key _otpKey = UniqueKey();

  static const int _otpLength = 6;

  @override
  void dispose() {
    _otpTimer?.cancel();
    _aadhaarController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<KYCProvider>();
    final record = provider.record;
    if (!_hydrated && record != null) {
      _aadhaarController.text = record.aadhaarNumber ?? '';
      _hydrated = true;
      _otpVisible = record.status != KYCStatus.verified && record.otpRequestedAt != null;
      if (record.otpRequestedAt != null) {
        final elapsed = DateTime.now().difference(record.otpRequestedAt!);
        final remaining = 60 - elapsed.inSeconds;
        if (remaining > 0) {
          _secondsLeft = remaining;
          _startCountdown();
        }
      }
    }
    if (record?.status == KYCStatus.verified) {
      _otpVisible = false;
      _secondsLeft = 0;
      _otpTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        title: const Text('KYC Verification'),
      ),
      body: Consumer<KYCProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final record = provider.record ?? const KycRecord(status: KYCStatus.notStarted);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatusCard(record: record),
                const SizedBox(height: 16),
                _buildAadhaarCard(provider, record),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAadhaarCard(KYCProvider provider, KycRecord record) {
    final isVerified = record.status == KYCStatus.verified;

    return _KycSectionCard(
      title: 'Identity Verification',
      subtitle: 'Enter Aadhaar number and verify via OTP. (demo code 123456).',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _aadhaarController,
            keyboardType: TextInputType.number,
            maxLength: 14,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              AadhaarInputFormatter(),
            ],
            decoration: InputDecoration(
              labelText: 'Aadhaar number',
              hintText: '1234 5678 9123',
              counterText: '',
              errorText: _aadhaarError,
            ),
            style: const TextStyle(fontFamily: 'Times New Roman'),
            onChanged: (_) {
              if (_aadhaarError != null) {
                setState(() => _aadhaarError = null);
              }
            },
          ),
          const SizedBox(height: 12),
          if (!isVerified) ...[
            ElevatedButton(
              onPressed: _sendingOtp ? null : () => _sendOtp(provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: _sendingOtp
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Send OTP',
                      style: TextStyle(fontFamily: 'Times New Roman', fontWeight: FontWeight.w700),
                    ),
            ),
          ],
          if (_otpVisible && !isVerified) ...[
            const SizedBox(height: 16),
            OtpInput(
              key: _otpKey,
              length: _otpLength,
              enabled: !_verifyingOtp,
              onChanged: (value) {
                setState(() {
                  _otpValue = value;
                  _otpError = null;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _secondsLeft > 0 ? 'Resend OTP in ${_secondsLeft}s' : 'Didn\'t receive OTP?',
                  style: const TextStyle(fontFamily: 'Times New Roman', color: Color(0xFF666666)),
                ),
                TextButton(
                  onPressed: (_secondsLeft > 0 || _sendingOtp) ? null : () => _sendOtp(provider, resend: true),
                  child: const Text('Resend OTP', style: TextStyle(fontFamily: 'Times New Roman')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: (_otpValue.length == _otpLength && !_verifyingOtp) ? () => _verifyOtp(provider) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: _verifyingOtp
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Verify OTP',
                      style: TextStyle(fontFamily: 'Times New Roman', fontWeight: FontWeight.w700),
                    ),
            ),
            if (_otpError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _otpError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ),
          ],
          if (record.status == KYCStatus.verified)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'KYC verified',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _sendOtp(KYCProvider provider, {bool resend = false}) async {
    if (provider.record?.status == KYCStatus.verified) return;
    final raw = _aadhaarController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.length != 12) {
      setState(() => _aadhaarError = 'Enter a valid 12-digit Aadhaar');
      return;
    }
    setState(() => _sendingOtp = true);
    await provider.sendOtp(raw);
    if (!mounted) return;
    setState(() {
      _sendingOtp = false;
      _otpVisible = true;
      _otpValue = '';
      _otpError = null;
      _otpKey = UniqueKey();
    });
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resend ? 'OTP resent' : 'OTP sent')),
    );
  }

  void _startCountdown() {
    _otpTimer?.cancel();
    setState(() => _secondsLeft = 60);
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  Future<void> _verifyOtp(KYCProvider provider) async {
    if (_otpValue.length != _otpLength) {
      setState(() => _otpError = 'Enter the 6-digit OTP');
      return;
    }
    setState(() => _verifyingOtp = true);
    final success = await provider.verifyOtp(_otpValue);
    if (!mounted) return;
    setState(() {
      _verifyingOtp = false;
      _otpError = success ? null : 'Invalid OTP';
      if (success) {
        _otpVisible = false;
        _otpValue = '';
        _secondsLeft = 0;
        _otpTimer?.cancel();
        _otpKey = UniqueKey();
      } else {
        _otpValue = '';
        _otpKey = UniqueKey();
      }
    });
    if (success) {
      await context.read<ProfileProvider>().refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('KYC verified')),
      );
    }
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.record});

  final KycRecord record;

  @override
  Widget build(BuildContext context) {
    final status = record.status;
    late Color color;
    late IconData icon;
    late String label;
    late String description;

    switch (status) {
      case KYCStatus.verified:
        color = Colors.green;
        icon = Icons.verified;
        label = 'Verified';
        final timestamp = record.history.isNotEmpty ? record.history.last.timestamp : DateTime.now();
        description = 'Verified on ${DateFormat('dd MMM, hh:mm a').format(timestamp)}';
        break;
      case KYCStatus.pending:
      case KYCStatus.rejected:
        color = Colors.orange;
        icon = Icons.access_time;
        label = 'Verification pending';
        description = 'Complete the steps below to finish verification.';
        break;
      case KYCStatus.notStarted:
        color = Colors.blueGrey;
        icon = Icons.shield_outlined;
        label = 'Not started';
        description = 'Complete the steps below to finish verification.';
        break;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Times New Roman',
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KycSectionCard extends StatelessWidget {
  const _KycSectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (var i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
