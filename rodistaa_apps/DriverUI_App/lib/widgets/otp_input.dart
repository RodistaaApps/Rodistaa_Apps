import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.onSubmit,
    required this.onCancel,
    this.length = 4,
    this.isVerifying = false,
  });

  final Future<void> Function(String otp) onSubmit;
  final VoidCallback onCancel;
  final int length;
  final bool isVerifying;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;
  int _attempts = 0;
  static const int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_nodes.isNotEmpty) {
        FocusScope.of(context).requestFocus(_nodes.first);
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(int index, String value) {
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_nodes[index - 1]);
      _controllers[index - 1].selection = TextSelection.collapsed(
        offset: _controllers[index - 1].text.length,
      );
      return;
    }

    if (value.isNotEmpty && index < _nodes.length - 1) {
      FocusScope.of(context).requestFocus(_nodes[index + 1]);
    } else if (_isOtpComplete) {
      _submit();
    }
  }

  void _handlePaste(String value) {
    final sanitized = value.replaceAll(RegExp('[^0-9]'), '');
    for (var i = 0; i < widget.length; i++) {
      final char = sanitized.characters.elementAtOrNull(i) ?? '';
      _controllers[i].text = char;
    }
    if (_isOtpComplete) {
      _submit();
    }
  }

  Future<void> _submit() async {
    if (widget.isVerifying) return;
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == widget.length) {
      await widget.onSubmit(otp);
      setState(() => _attempts++);
    }
  }

  bool get _isOtpComplete =>
      _controllers.every((controller) => controller.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final textTheme = RodistaaTheme.serifTextTheme(Theme.of(context).textTheme);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: RodistaaTheme.gapS),
              child: SizedBox(
                width: 56,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _nodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => _handleChanged(index, value),
                  decoration: const InputDecoration(counterText: ''),
                  style: textTheme.titleLarge,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: RodistaaTheme.gapL),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: widget.isVerifying ? null : widget.onCancel,
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: widget.isVerifying ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: RodistaaTheme.rodistaaRed,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: widget.isVerifying
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Submit'),
            ),
          ],
        ),
        if (_attempts >= _maxAttempts)
          Padding(
            padding: const EdgeInsets.only(top: RodistaaTheme.gapM),
            child: TextButton.icon(
              onPressed: widget.isVerifying ? null : widget.onCancel,
              icon: const Icon(Icons.support_agent_outlined),
              label: const Text('Contact Support'),
            ),
          ),
      ],
    );
  }
}
