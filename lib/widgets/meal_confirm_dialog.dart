import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../theme/app_theme.dart';
import 'ui_components.dart';

Future<bool> showMealConfirmDialog(
  BuildContext context, {
  required String description,
  required int calories,
  required String mealType,
  String? notes,
  Uint8List? imageBytes,
}) {
  return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => MealConfirmDialog(
          description: description,
          calories: calories,
          mealType: mealType,
          notes: notes,
          imageBytes: imageBytes,
        ),
      ).then(
        (value) => value ?? false,
      );
}

class MealConfirmDialog extends StatelessWidget {
  const MealConfirmDialog({
    super.key,
    required this.description,
    required this.calories,
    required this.mealType,
    this.notes,
    this.imageBytes,
  });

  final String description;
  final int calories;
  final String mealType;
  final String? notes;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mealStyle = _mealStyle(mealType);
    final mealLabel = l10n.mealTypeLabel(mealType);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconBadge(
                    icon: Icons.auto_awesome_rounded,
                    color: AppTheme.primary,
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.mealDetected,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.reviewBeforeAdding,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (imageBytes != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: mealStyle.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        mealStyle.icon,
                        color: mealStyle.color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: mealStyle.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: mealStyle.color.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              mealLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: mealStyle.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: AppTheme.softGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.estimatedCalories,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.primaryDark.withValues(alpha: 0.7),
                            letterSpacing: 0.8,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$calories',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppTheme.primaryDark,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            l10n.kcal,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (notes != null && notes!.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  notes!.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        height: 1.45,
                      ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(l10n.notNow),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: Text(l10n.addMeal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealStyle {
  const _MealStyle({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}

_MealStyle _mealStyle(String mealType) {
  final type = mealType.toLowerCase();
  if (type.contains('breakfast')) {
    return const _MealStyle(
      icon: Icons.wb_sunny_outlined,
      color: Color(0xFFFFA726),
    );
  }
  if (type.contains('lunch')) {
    return const _MealStyle(
      icon: Icons.lunch_dining,
      color: Color(0xFF42A5F5),
    );
  }
  if (type.contains('dinner')) {
    return const _MealStyle(
      icon: Icons.dinner_dining,
      color: Color(0xFF7E57C2),
    );
  }
  if (type.contains('snack')) {
    return const _MealStyle(
      icon: Icons.cookie_outlined,
      color: Color(0xFF66BB6A),
    );
  }
  return const _MealStyle(
    icon: Icons.restaurant,
    color: AppTheme.primary,
  );
}
