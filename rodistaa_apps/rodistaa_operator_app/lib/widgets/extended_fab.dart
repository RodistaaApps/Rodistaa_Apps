import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ExtendedFab extends StatelessWidget {
  const ExtendedFab({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final showLabel = width > 380; // show label on wider devices

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FloatingActionButton.extended(
        onPressed: onTap,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        heroTag: 'add_driver_fab',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

