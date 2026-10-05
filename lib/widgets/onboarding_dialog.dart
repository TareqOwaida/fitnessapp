import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import 'ui_components.dart';

const _exerciseOptions = [
  (id: 'strength', icon: Icons.fitness_center),
  (id: 'cardio', icon: Icons.directions_run),
  (id: 'hiit', icon: Icons.bolt),
  (id: 'flexibility', icon: Icons.self_improvement),
  (id: 'upper_body', icon: Icons.sports_gymnastics),
  (id: 'lower_body', icon: Icons.accessibility_new),
];

Future<void> showOnboardingDialog(
  BuildContext context, {
  required UserProfile profile,
  required UserService userService,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (context) => OnboardingDialog(
      profile: profile,
      userService: userService,
    ),
  );
}

class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({
    super.key,
    required this.profile,
    required this.userService,
  });

  final UserProfile profile;
  final UserService userService;

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  int _step = 0;
  bool _saving = false;
  String? _error;

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _calorieController = TextEditingController(text: '2000');

  final Set<String> _selectedExercises = {};
  String _workoutLocation = 'gym';

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _calorieController.dispose();
    super.dispose();
  }

  List<String> _stepTitles(AppLocalizations l10n) => [
        l10n.aboutYou,
        l10n.calorieGoalStep,
        l10n.yourWorkouts,
      ];

  void _next() {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _error = null);

    if (_step == 0) {
      final age = int.tryParse(_ageController.text.trim());
      final height = double.tryParse(_heightController.text.trim());
      final weight = double.tryParse(_weightController.text.trim());

      if (age == null || age < 13 || age > 120) {
        setState(() => _error = l10n.enterValidAge);
        return;
      }
      if (height == null || height < 100 || height > 250) {
        setState(() => _error = l10n.enterValidHeight);
        return;
      }
      if (weight == null || weight < 30 || weight > 300) {
        setState(() => _error = l10n.enterValidWeight);
        return;
      }
    } else if (_step == 1) {
      final goal = int.tryParse(_calorieController.text.trim());
      if (goal == null || goal < 500 || goal > 10000) {
        setState(() => _error = l10n.enterDailyGoalRangeKcal);
        return;
      }
    }

    setState(() => _step++);
  }

  void _back() {
    setState(() {
      _step--;
      _error = null;
    });
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedExercises.isEmpty) {
      setState(() => _error = l10n.selectExerciseType);
      return;
    }

    final age = int.parse(_ageController.text.trim());
    final height = double.parse(_heightController.text.trim());
    final weight = double.parse(_weightController.text.trim());
    final goal = int.parse(_calorieController.text.trim());

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await widget.userService.completeOnboarding(
        uid: widget.profile.id,
        dailyCalorieGoal: goal,
        age: age,
        heightCm: height,
        weightKg: weight,
        preferredExercises: _selectedExercises.toList(),
        preferredWorkoutLocation: _workoutLocation,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = l10n.couldNotSavePreferences);
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stepTitles = _stepTitles(l10n);
    final isLastStep = _step == stepTitles.length - 1;

    final maxDialogHeight = MediaQuery.sizeOf(context).height * 0.85;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420, maxHeight: maxDialogHeight),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const FitenneLogo(size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.welcomeToFitenne,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.personalizeExperience,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _StepIndicator(current: _step, total: stepTitles.length),
              const SizedBox(height: 20),
              Text(
                stepTitles[_step],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),
              _buildStepContent(),
              if (_error != null) ...[
                const SizedBox(height: 12),
                FeedbackBanner(message: _error!),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  if (_step > 0)
                    TextButton(
                      onPressed: _saving ? null : _back,
                      child: Text(l10n.back),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _saving
                        ? null
                        : isLastStep
                            ? _finish
                            : _next,
                    child: Text(
                      _saving
                          ? l10n.saving
                          : isLastStep
                              ? l10n.getStarted
                              : l10n.continueButton,
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

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _BodyStatsStep(
          ageController: _ageController,
          heightController: _heightController,
          weightController: _weightController,
        );
      case 1:
        return _CalorieStep(calorieController: _calorieController);
      case 2:
        return _ExerciseStep(
          selected: _selectedExercises,
          workoutLocation: _workoutLocation,
          onExerciseToggled: (id) {
            setState(() {
              if (_selectedExercises.contains(id)) {
                _selectedExercises.remove(id);
              } else {
                _selectedExercises.add(id);
              }
              _error = null;
            });
          },
          onLocationChanged: (value) => setState(() => _workoutLocation = value),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isActive = index <= current;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < total - 1 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primary : AppTheme.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}

class _BodyStatsStep extends StatelessWidget {
  const _BodyStatsStep({
    required this.ageController,
    required this.heightController,
    required this.weightController,
  });

  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.aboutYouHint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: ageController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.age,
            suffixText: l10n.years,
            prefixIcon: const Icon(Icons.cake_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: heightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            labelText: l10n.height,
            suffixText: l10n.cm,
            prefixIcon: const Icon(Icons.height),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            labelText: l10n.weight,
            suffixText: l10n.kg,
            prefixIcon: const Icon(Icons.monitor_weight_outlined),
          ),
        ),
      ],
    );
  }
}

class _CalorieStep extends StatelessWidget {
  const _CalorieStep({required this.calorieController});

  final TextEditingController calorieController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.calorieGoalQuestion,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: calorieController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.dailyCalorieGoal,
            suffixText: l10n.kcal,
            prefixIcon: const Icon(Icons.local_fire_department_outlined),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in [1500, 1800, 2000, 2200, 2500])
              ActionChip(
                label: Text(l10n.presetKcal(preset)),
                onPressed: () => calorieController.text = preset.toString(),
                backgroundColor: AppTheme.surface,
                side: const BorderSide(color: AppTheme.border),
              ),
          ],
        ),
      ],
    );
  }
}

class _ExerciseStep extends StatelessWidget {
  const _ExerciseStep({
    required this.selected,
    required this.workoutLocation,
    required this.onExerciseToggled,
    required this.onLocationChanged,
  });

  final Set<String> selected;
  final String workoutLocation;
  final ValueChanged<String> onExerciseToggled;
  final ValueChanged<String> onLocationChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.exerciseTypesQuestion,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in _exerciseOptions)
              FilterChip(
                label: Text(l10n.onboardingExerciseLabel(option.id)),
                avatar: Icon(option.icon, size: 18),
                selected: selected.contains(option.id),
                onSelected: (_) => onExerciseToggled(option.id),
                selectedColor: AppTheme.primary.withValues(alpha: 0.15),
                checkmarkColor: AppTheme.primary,
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          l10n.workoutLocationQuestion,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
        ),
        const SizedBox(height: 10),
        LocationToggle<String>(
          selected: workoutLocation,
          onChanged: onLocationChanged,
          options: [
            (value: 'gym', label: l10n.gym, icon: Icons.fitness_center),
            (value: 'home', label: l10n.home, icon: Icons.home_filled),
          ],
        ),
      ],
    );
  }
}
