import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// OTP input widget with 4 boxes and auto-advance functionality
/// 
/// Supports:
/// - Auto-advance between boxes
/// - Paste support for 4-digit codes
/// - Backspace handling
class OTPInput extends StatefulWidget {
  final Function(String) onOTPComplete;
  final Function(String) onOTPChanged;
  
  const OTPInput({
    super.key,
    required this.onOTPComplete,
    required this.onOTPChanged,
  });

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  @override
  void initState() {
    super.initState();
    
    // Add listeners to handle auto-advance
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        _onTextChanged(i);
      });
    }
  }
  
  void _onTextChanged(int index) {
    final text = _controllers[index].text;
    
    // Handle paste (4 digits pasted into first box)
    if (index == 0 && text.length == 4 && RegExp(r'^[0-9]{4}$').hasMatch(text)) {
      _handlePaste(text);
      return;
    }
    
    // Auto-advance to next box
    if (text.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Notify parent of OTP change
    final otp = _getOTP();
    widget.onOTPChanged(otp);
    
    // Notify when all 4 digits are entered
    if (otp.length == 4) {
      widget.onOTPComplete(otp);
    }
  }
  
  void _handlePaste(String pastedText) {
    // Distribute pasted digits across boxes
    for (int i = 0; i < 4; i++) {
      _controllers[i].text = pastedText[i];
    }
    _focusNodes[3].requestFocus();
    
    // Notify complete
    widget.onOTPComplete(pastedText);
  }
  
  String _getOTP() {
    return _controllers.map((c) => c.text).join();
  }
  
  void _onKeyEvent(int index, RawKeyEvent event) {
    // Handle backspace
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return _OTPBox(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onKeyEvent: (event) => _onKeyEvent(index, event),
        );
      }),
    );
  }
}

/// Individual OTP box widget
class _OTPBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(RawKeyEvent) onKeyEvent;
  
  const _OTPBox({
    required this.controller,
    required this.focusNode,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: onKeyEvent,
        child: Semantics(
          label: 'OTP digit box',
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4), // Allow paste of 4 digits
            ],
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
