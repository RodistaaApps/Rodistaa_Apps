import 'package:flutter/material.dart';

import '../utils/constants.dart';

class LanguageModal extends StatelessWidget {
  const LanguageModal({
    super.key,
    required this.currentLocale,
    required this.onSelected,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Semantics(
        label: LoginUIConstants.selectLanguageTitle,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LoginUIConstants.selectLanguageTitle,
                style: TextStyle(
                  fontFamily: LoginUIConstants.bodyFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: LoginUIConstants.brandRed,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: LoginUIConstants.languages
                    .map(
                      (option) => _LanguageChip(
                        label: option.label,
                        isSelected: currentLocale.languageCode == option.locale.languageCode,
                        onTap: () => onSelected(option.locale),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background = isSelected ? Colors.white : LoginUIConstants.brandRed;
    final Color textColor = isSelected ? LoginUIConstants.brandRed : Colors.white;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: LoginUIConstants.brandRed, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: LoginUIConstants.bodyFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? LoginUIConstants.brandRed : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

