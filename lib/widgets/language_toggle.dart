import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'ui_components.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
    required this.isArabic,
    required this.onEnglish,
    required this.onArabic,
    this.compact = false,
  });

  final bool isArabic;
  final VoidCallback onEnglish;
  final VoidCallback onArabic;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (compact) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isArabic ? onEnglish : onArabic,
          borderRadius: BorderRadius.circular(99),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Text(
              isArabic ? 'EN' : 'ع',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.language,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
        ),
        const SizedBox(height: 10),
        LocationToggle<bool>(
          selected: isArabic,
          onChanged: (value) => value ? onArabic() : onEnglish(),
          options: [
            (value: false, label: l10n.english, icon: Icons.language),
            (value: true, label: l10n.arabic, icon: Icons.translate),
          ],
        ),
      ],
    );
  }
}
