import 'package:flutter/material.dart';

import '../constants/colors.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.enabled = true,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<String> _values;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _values = List.filled(widget.length, '');
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String value, int index) {
    if (value.length > 1) {
      _fillFromPaste(value);
      return;
    }
    _values[index] = value;

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    widget.onChanged(_values.join());
    setState(() {});
  }

  void _fillFromPaste(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    for (var i = 0; i < widget.length; i++) {
      final char = i < digits.length ? digits[i] : '';
      _values[i] = char;
      _controllers[i].text = char;
    }
    if (digits.isNotEmpty) {
      final nextIndex = digits.length.clamp(0, widget.length - 1);
      _focusNodes[nextIndex].requestFocus();
    }
    widget.onChanged(_values.join());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final boxes = List.generate(widget.length, (index) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: index == widget.length - 1 ? 0 : 8),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            enabled: widget.enabled,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Times New Roman',
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primaryRed),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.5)),
              ),
            ),
            onChanged: (value) => _handleChanged(value, index),
          ),
        ),
      );
    });

    return Row(children: boxes);
  }
}

