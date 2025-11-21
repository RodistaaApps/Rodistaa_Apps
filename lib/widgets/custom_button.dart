import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.margin,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsets? margin;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  static const _pressedScale = 0.97;
  late final AnimationController _controller;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      upperBound: 1,
      lowerBound: _pressedScale,
      value: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isEnabled) {
      _controller.animateTo(_pressedScale);
    }
  }

  void _handleTapUp([TapUpDetails? details]) {
    if (_isEnabled) {
      _controller.animateTo(1, duration: const Duration(milliseconds: 120));
    }
  }

  void _handleTapCancel() {
    if (_isEnabled) {
      _controller.animateTo(1, duration: const Duration(milliseconds: 120));
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: _isEnabled
          ? AppColors.primaryRed
          : AppColors.primaryRed.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _isEnabled ? widget.onPressed : null,
        borderRadius: BorderRadius.circular(16),
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: widget.isLoading
              ? Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  widget.label,
                  style: AppTextStyles.buttonText,
                ),
        ),
      ),
    );

    return Container(
      margin: widget.margin,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}
