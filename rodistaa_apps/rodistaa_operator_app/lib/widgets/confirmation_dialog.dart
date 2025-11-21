import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final bool isDestructive;

  /// Static method for backward compatibility with existing code
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    required VoidCallback onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        onConfirm: () {
          Navigator.pop(dialogContext, true);
          onConfirm();
        },
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final rodistaaRed = AppColors.primaryRed;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Times New Roman',
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Times New Roman',
          fontSize: 14,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            cancelLabel,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? Colors.red : rodistaaRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmLabel,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
