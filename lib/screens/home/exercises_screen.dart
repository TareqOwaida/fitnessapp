import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_extensions.dart';
import '../../models/exercise.dart';
import '../../services/exercise_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui_components.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key, required this.user});

  final User user;

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final _exerciseService = ExerciseService();
  WorkoutLocation _filter = WorkoutLocation.gym;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _seedPlans();
  }

  Future<void> _seedPlans() async {
    await _exerciseService.seedDefaultPlans(widget.user.uid);
    if (mounted) {
      setState(() => _seeded = true);
    }
  }

  WorkoutDay get _today {
    final weekday = DateTime.now().weekday;
    return WorkoutDay.values[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_seeded) {
      return Scaffold(
        body: Center(child: BrandedLoader(message: l10n.loadingWorkouts)),
      );
    }

    return Scaffold(
      body: StreamBuilder<List<WorkoutPlan>>(
        stream: _exerciseService.streamPlans(widget.user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: BrandedLoader(message: l10n.loadingWorkouts),
            );
          }

          final plans = (snapshot.data ?? [])
              .where((plan) => plan.location == _filter)
              .toList();

          final todayMatches =
              plans.where((plan) => plan.day == _today).toList();
          final todayPlan =
              todayMatches.isEmpty ? null : todayMatches.first;
          final otherPlans =
              plans.where((plan) => plan.day != _today).toList();

          return CustomScrollView(
            slivers: [
              GradientHeader(
                title: l10n.workouts,
                subtitle: _filter == WorkoutLocation.gym
                    ? l10n.gymTrainingPlan
                    : l10n.homeTrainingPlan,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: LocationToggle<WorkoutLocation>(
                    selected: _filter,
                    onChanged: (value) => setState(() => _filter = value),
                    options: [
                      (
                        value: WorkoutLocation.gym,
                        label: l10n.gym,
                        icon: Icons.fitness_center,
                      ),
                      (
                        value: WorkoutLocation.home,
                        label: l10n.home,
                        icon: Icons.home_filled,
                      ),
                    ],
                  ),
                ),
              ),
              if (plans.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: EmptyStateView(
                      icon: Icons.fitness_center_rounded,
                      title: l10n.noWorkoutsYet,
                      message: l10n.noWorkoutsHint,
                    ),
                  ),
                )
              else ...[
                if (todayPlan != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: _TodayWorkoutHero(plan: todayPlan),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: todayPlan != null ? l10n.thisWeek : l10n.yourPlan,
                    trailing: StatBadge(
                      label: l10n.sessions,
                      value: '${plans.length}',
                      icon: Icons.calendar_month,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final plan = todayPlan != null
                            ? otherPlans[index]
                            : plans[index];
                        return _WorkoutDayCard(
                          plan: plan,
                          isToday: plan.day == _today,
                        );
                      },
                      childCount:
                          todayPlan != null ? otherPlans.length : plans.length,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _TodayWorkoutHero extends StatelessWidget {
  const _TodayWorkoutHero({required this.plan});

  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PremiumCard(
      gradient: AppTheme.heroGradient,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.accentWarm,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.today,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                plan.location == WorkoutLocation.gym
                    ? Icons.fitness_center
                    : Icons.home_filled,
                color: Colors.white.withValues(alpha: 0.8),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            plan.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.exercisesCountMinutes(
              plan.exercises.length,
              plan.durationMinutes,
            ),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _HeroStat(
                icon: Icons.repeat,
                label: l10n.exercises,
                value: '${plan.exercises.length}',
              ),
              const SizedBox(width: 12),
              _HeroStat(
                icon: Icons.timer_outlined,
                label: l10n.duration,
                value: l10n.minutesShort(plan.durationMinutes),
              ),
              const SizedBox(width: 12),
              _HeroStat(
                icon: Icons.local_fire_department_outlined,
                label: l10n.intensity,
                value: plan.exercises.length > 5 ? l10n.high : l10n.med,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.9)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutDayCard extends StatefulWidget {
  const _WorkoutDayCard({
    required this.plan,
    required this.isToday,
  });

  final WorkoutPlan plan;
  final bool isToday;

  @override
  State<_WorkoutDayCard> createState() => _WorkoutDayCardState();
}

class _WorkoutDayCardState extends State<_WorkoutDayCard> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isToday;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dayColor = _dayColor(widget.plan.day);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: dayColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        widget.isToday
                            ? Icons.bolt
                            : Icons.calendar_today_outlined,
                        color: dayColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.plan.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.workoutDaySummary(
                              l10n.weekday(widget.plan.day),
                              widget.plan.durationMinutes,
                              widget.plan.exercises.length,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  const Divider(height: 1),
                  ...widget.plan.exercises.asMap().entries.map((entry) {
                    final index = entry.key;
                    final exercise = entry.value;
                    return _ExerciseRow(
                      index: index + 1,
                      exercise: exercise,
                      accentColor: dayColor,
                    );
                  }),
                ],
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeOutCubic,
            ),
          ],
        ),
      ),
    );
  }

  Color _dayColor(WorkoutDay day) {
    const colors = [
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFFEF4444),
      Color(0xFF06B6D4),
      Color(0xFFEC4899),
    ];
    return colors[day.index % colors.length];
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.index,
    required this.exercise,
    required this.accentColor,
  });

  final int index;
  final ExerciseItem exercise;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: accentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _ExerciseChip(
                      label: l10n.setsCount(exercise.sets),
                      color: accentColor,
                    ),
                    const SizedBox(width: 6),
                    _ExerciseChip(
                      label: exercise.reps,
                      color: accentColor,
                    ),
                    const SizedBox(width: 6),
                    _ExerciseChip(
                      label: l10n.restSeconds(exercise.restSeconds),
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
                if (exercise.notes != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    exercise.notes!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseChip extends StatelessWidget {
  const _ExerciseChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
