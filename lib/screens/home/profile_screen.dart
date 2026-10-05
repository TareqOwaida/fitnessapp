import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_extensions.dart';
import '../../models/user_profile.dart';
import '../../services/locale_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/ui_components.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final User user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();

  String? _preferredLocation;
  bool _saving = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _populateForm(UserProfile profile) {
    if (_nameController.text.isEmpty) {
      _nameController.text = profile.displayName;
    }
    if (_goalController.text.isEmpty) {
      _goalController.text = profile.dailyCalorieGoal.toString();
    }
    _preferredLocation ??= profile.preferredWorkoutLocation;
  }

  Future<void> _save(UserProfile profile) async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final goal = int.tryParse(_goalController.text.trim());

    if (name.isEmpty) {
      setState(() => _error = l10n.enterYourName);
      return;
    }
    if (goal == null || goal < 500 || goal > 10000) {
      setState(() => _error = l10n.enterDailyGoalRange);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
      _success = null;
    });

    try {
      await _userService.updateProfile(
        profile.copyWith(
          displayName: name,
          dailyCalorieGoal: goal,
          preferredWorkoutLocation: _preferredLocation,
        ),
      );

      if (widget.user.displayName != name) {
        await widget.user.updateDisplayName(name);
      }

      if (mounted) {
        setState(() => _success = l10n.profileSaved);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = l10n.couldNotSaveProfile('$error'));
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
    final localeService = context.watch<LocaleService>();

    return Scaffold(
      body: StreamBuilder<UserProfile?>(
        stream: _userService.streamProfile(widget.user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: BrandedLoader(message: l10n.loadingProfile),
            );
          }

          final profile = snapshot.data;
          if (profile == null) {
            return Center(
              child: BrandedLoader(message: l10n.settingUpProfile),
            );
          }

          _populateForm(profile);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                stretch: true,
                backgroundColor: AppTheme.primaryDark,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppTheme.heroGradient,
                        ),
                      ),
                      Positioned(
                        right: -50,
                        top: 10,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -40,
                        bottom: 20,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.accent.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 56),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UserAvatar(
                                name: profile.displayName.isNotEmpty
                                    ? profile.displayName
                                    : l10n.fitenneUser,
                                size: 80,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                profile.displayName.isNotEmpty
                                    ? profile.displayName
                                    : l10n.yourProfile,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.email,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PremiumCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _ProfileMetric(
                                  icon: Icons.flag_outlined,
                                  label: l10n.dailyGoal,
                                  value: '${profile.dailyCalorieGoal}',
                                  unit: l10n.kcal,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _ProfileMetric(
                                  icon: Icons.place_outlined,
                                  label: l10n.workout,
                                  value: l10n.workoutLocationLabel(
                                    profile.preferredWorkoutLocation,
                                  ),
                                  unit: '',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const IconBadge(
                              icon: Icons.edit_outlined,
                              size: 40,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.editProfile,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: l10n.displayName,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _goalController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: l10n.dailyCalorieGoal,
                            suffixText: l10n.kcal,
                            prefixIcon: const Icon(
                              Icons.local_fire_department_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.preferredWorkoutLocation,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 10),
                        LocationToggle<String>(
                          selected: _preferredLocation ?? 'gym',
                          onChanged: _saving
                              ? (_) {}
                              : (value) =>
                                    setState(() => _preferredLocation = value),
                          options: [
                            (
                              value: 'gym',
                              label: l10n.gym,
                              icon: Icons.fitness_center,
                            ),
                            (
                              value: 'home',
                              label: l10n.home,
                              icon: Icons.home_filled,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        LanguageToggle(
                          isArabic: localeService.isArabic,
                          onEnglish: localeService.setEnglish,
                          onArabic: localeService.setArabic,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          FeedbackBanner(message: _error!),
                        ],
                        if (_success != null) ...[
                          const SizedBox(height: 16),
                          FeedbackBanner(message: _success!, isError: false),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _saving ? null : () => _save(profile),
                            child: _saving
                                ? const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(l10n.saveChanges),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _saving
                                ? null
                                : () => FirebaseAuth.instance.signOut(),
                            icon: const Icon(Icons.logout),
                            label: Text(l10n.signOut),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.softGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
