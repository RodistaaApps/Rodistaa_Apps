import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/language_modal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _otpSent = false;
  bool _isSending = false;
  bool _isVerifying = false;
  int _secondsRemaining = 0;
  Timer? _timer;
  String? _mobileError;
  String? _otpError;

  @override
  void dispose() {
    _mobileController.dispose();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _otpFocusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  String get _otpValue =>
      _otpControllers.map((controller) => controller.text).join();

  bool get _canSendOtp =>
      _mobileController.text.trim().length == 10 && !_isSending;

  bool get _canLogin =>
      _otpSent && _otpValue.length == 4 && !_isVerifying && _mobileError == null;

  bool get _canResend => _secondsRemaining == 0 && _otpSent && !_isSending;

  Future<void> _handleSendOtp() async {
    final mobile = _mobileController.text.trim();
    if (mobile.length != 10) {
      setState(() {
        _mobileError = LoginUIConstants.mobileErrorText;
      });
      return;
    }
    setState(() {
      _mobileError = null;
      _isSending = true;
    });
    await AuthService.sendOtp(mobile);
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _otpSent = true;
      _otpError = null;
    });
    _startCountdown();
    _otpFocusNodes.first.requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(LoginUIConstants.otpSentMessage)),
    );
  }

  Future<void> _handleVerifyOtp() async {
    if (!_canLogin) {
      setState(() {
        _otpError = LoginUIConstants.otpErrorText;
      });
      return;
    }
    setState(() {
      _otpError = null;
      _isVerifying = true;
    });
    final authProvider = context.read<AuthProvider>();
    final mobile = _mobileController.text.trim();
    await AuthService.verifyOtp(mobileNumber: mobile, otp: _otpValue);
    await authProvider.login(mobile);
    if (!mounted) return;
    setState(() => _isVerifying = false);
    if (!mounted) return;
    context.go('/home');
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = LoginUIConstants.otpCountdown.inSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _openLanguageModal() {
    final provider = context.read<LanguageProvider>();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => LanguageModal(
        currentLocale: provider.currentLocale,
        onSelected: (locale) async {
          await provider.changeLanguage(locale);
          if (!mounted) return;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _handleOtpChanged(int index, String value) {
    String digit = value;
    if (digit.length > 1) {
      digit = digit.substring(digit.length - 1);
    }
    _otpControllers[index].value = TextEditingValue(
      text: digit,
      selection: TextSelection.collapsed(offset: digit.length),
    );

    if (digit.isNotEmpty && index < _otpFocusNodes.length - 1) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (digit.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    setState(() {
      _otpError = null;
    });

    if (_otpSent && _otpValue.length == 4 && !_isVerifying) {
      _handleVerifyOtp();
    }
  }

  void _handleMobileChanged(String value) {
    setState(() {
      if (value.length == 10) {
        _mobileError = null;
      }
      // Reset OTP state if number is changed
      if (_otpSent) {
        _otpSent = false;
        _isVerifying = false;
        for (final c in _otpControllers) {
          c.clear();
        }
        _timer?.cancel();
        _secondsRemaining = 0;
      }
    });
  }

  ButtonStyle _primaryButtonStyle(Color activeColor) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LoginUIConstants.buttonRadius),
      ),
      backgroundColor: activeColor,
      foregroundColor: Colors.white,
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? Colors.grey.shade300 : activeColor,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? Colors.grey.shade600 : Colors.white,
      ),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontFamily: LoginUIConstants.bodyFont,
          fontSize: LoginUIConstants.buttonFontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _formatSeconds(int seconds) {
    final int safeSeconds =
        seconds.clamp(0, LoginUIConstants.otpCountdown.inSeconds).toInt();
    return '00:${safeSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isTablet = size.shortestSide >= 600;
    final headerFraction =
        isTablet ? LoginUIConstants.headerTabletFraction : LoginUIConstants.headerPhoneFraction;
    final headerHeight = math.min(size.height * headerFraction, size.height * 0.5);
    final cardWidth = size.width * LoginUIConstants.cardWidthFraction;
    final double horizontalInset = math.max((size.width - cardWidth) / 2, 16);
    final double wordmarkSize = isTablet ? 48 : 36;
    final double taglineSize = isTablet ? 16 : 14;
    final double headerTopOffset = padding.top + headerHeight * 0.15;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  SizedBox(
                    height: headerHeight + padding.top,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: LoginUIConstants.brandRed,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: headerTopOffset,
                                left: 24,
                                right: 24,
                                bottom: 32,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Rodistaa',
                                    style: TextStyle(
                                      fontFamily: 'BalooBhai',
                                      fontSize: wordmarkSize,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    LoginUIConstants.tagline,
                                    style: TextStyle(
                                      fontFamily: LoginUIConstants.bodyFont,
                                      color: Colors.white.withValues(alpha: 0.87),
                                      fontSize: taglineSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: padding.top + 16,
                            right: 24,
                            child: Semantics(
                              button: true,
                              label: LoginUIConstants.languageText,
                              child: ElevatedButton(
                                onPressed: _openLanguageModal,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: LoginUIConstants.brandRed,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  LoginUIConstants.languageText,
                                  style: TextStyle(
                                    fontFamily: LoginUIConstants.bodyFont,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: LoginUIConstants.brandRed,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -LoginUIConstants.cardOverlap),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalInset),
                      child: _buildCard(),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard() {
    return Semantics(
      label: 'Login form',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(LoginUIConstants.cardPadding),
        decoration: BoxDecoration(
          color: LoginUIConstants.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LoginUIConstants.mobileLabel,
                style: TextStyle(
                  fontFamily: LoginUIConstants.bodyFont,
                  fontSize: LoginUIConstants.labelFontSize,
                  fontWeight: FontWeight.w700,
                  color: LoginUIConstants.brandRed,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇮🇳', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          '+91',
                          style: TextStyle(
                            fontFamily: LoginUIConstants.bodyFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _mobileController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: _handleMobileChanged,
                      style: TextStyle(
                        fontFamily: LoginUIConstants.bodyFont,
                        fontSize: LoginUIConstants.hintFontSize,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: LoginUIConstants.mobileHint,
                        hintStyle: TextStyle(
                          fontFamily: LoginUIConstants.bodyFont,
                          color: Colors.grey.withValues(alpha: 0.6),
                          fontSize: LoginUIConstants.hintFontSize,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: LoginUIConstants.brandRed, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: LoginUIConstants.brandRed, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_mobileError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _mobileError!,
                  style: TextStyle(
                    fontFamily: LoginUIConstants.bodyFont,
                    fontSize: 12,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: LoginUIConstants.sendButtonHeight,
                child: ElevatedButton(
                  onPressed: (_canSendOtp && !_otpSent) ? _handleSendOtp : null,
                  style: _primaryButtonStyle(LoginUIConstants.brandRed),
                  child: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          LoginUIConstants.sendOtpText,
                          style: TextStyle(
                            fontFamily: LoginUIConstants.bodyFont,
                            fontSize: LoginUIConstants.buttonFontSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LoginUIConstants.otpInfoText,
                style: TextStyle(
                  fontFamily: LoginUIConstants.bodyFont,
                  fontSize: LoginUIConstants.infoFontSize,
                  color: LoginUIConstants.otpHintColor,
                ),
              ),
              if (_otpSent) ...[
                const SizedBox(height: 24),
                Center(child: _buildOtpInputs(true)),
                if (_otpError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _otpError!,
                    style: TextStyle(
                      fontFamily: LoginUIConstants.bodyFont,
                      fontSize: 12,
                      color: Colors.red.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatSeconds(_secondsRemaining),
                      style: TextStyle(
                        fontFamily: LoginUIConstants.bodyFont,
                        fontSize: 14,
                        color: LoginUIConstants.brandRed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: _canResend ? _handleSendOtp : null,
                      child: Text(
                        LoginUIConstants.resendOtpText,
                        style: TextStyle(
                          fontFamily: LoginUIConstants.bodyFont,
                          color: _canResend
                              ? LoginUIConstants.brandRed
                              : Colors.grey.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (_otpSent) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: LoginUIConstants.loginButtonHeight,
                  child: ElevatedButton(
                    onPressed: _canLogin ? _handleVerifyOtp : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(LoginUIConstants.buttonRadius),
                      ),
                      backgroundColor:
                          _canLogin ? LoginUIConstants.brandRed : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontFamily: LoginUIConstants.bodyFont,
                        fontSize: LoginUIConstants.buttonFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(LoginUIConstants.loginText),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInputs(bool enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: LoginUIConstants.otpBoxSpacing / 2),
          child: SizedBox(
            width: LoginUIConstants.otpBoxSize,
            height: LoginUIConstants.otpBoxSize,
            child: TextField(
              controller: _otpControllers[index],
              focusNode: _otpFocusNodes[index],
              textAlign: TextAlign.center,
              enabled: enabled,
              textInputAction: index == 3 ? TextInputAction.done : TextInputAction.next,
              maxLength: 1,
              style: TextStyle(
                fontFamily: LoginUIConstants.bodyFont,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: LoginUIConstants.brandRed,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => _handleOtpChanged(index, value),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: LoginUIConstants.brandRed, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

