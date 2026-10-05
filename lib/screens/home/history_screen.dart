import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_extensions.dart';
import '../../models/calorie_entry.dart';
import '../../services/calorie_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui_components.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key, required this.user});

  final User user;
  final _calorieService = CalorieService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMEd(locale);
    final shortDate = DateFormat('EEE', locale);

    return Scaffold(
      body: StreamBuilder<List<DailyCalorieSummary>>(
        stream: _calorieService.streamHistory(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: BrandedLoader(message: l10n.loadingInsights),
            );
          }

          final summaries = snapshot.data ?? [];
          if (summaries.isEmpty) {
            return CustomScrollView(
              slivers: [
                GradientHeader(
                  title: l10n.insights,
                  subtitle: l10n.trackProgress,
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: EmptyStateView(
                      icon: Icons.insights_rounded,
                      title: l10n.noDataYet,
                      message: l10n.noDataHint,
                    ),
                  ),
                ),
              ],
            );
          }

          final recent = summaries.take(7).toList();
          final maxCalories = recent
              .map((s) => s.totalCalories)
              .fold<int>(0, (a, b) => a > b ? a : b);
          final weekTotal = recent.fold<int>(
            0,
            (sum, item) => sum + item.totalCalories,
          );
          final weekAvg = recent.isEmpty ? 0 : weekTotal ~/ recent.length;

          return CustomScrollView(
            slivers: [
              GradientHeader(
                title: l10n.insights,
                subtitle: l10n.nutritionTrends,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: PremiumCard(
                    gradient: AppTheme.heroGradient,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.lastNDays(recent.length),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$weekAvg',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 6, left: 4),
                              child: Text(
                                l10n.kcalAvg,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 110,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: recent.reversed.map((summary) {
                              final heightFactor = maxCalories > 0
                                  ? summary.totalCalories / maxCalories
                                  : 0.0;
                              final isHighest =
                                  summary.totalCalories == maxCalories;

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${summary.totalCalories}',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 600,
                                        ),
                                        curve: Curves.easeOutCubic,
                                        height: 56 * heightFactor + 8,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: isHighest
                                                ? [
                                                    AppTheme.accentWarm,
                                                    AppTheme.accentWarm
                                                        .withValues(alpha: 0.7),
                                                  ]
                                                : [
                                                    Colors.white.withValues(
                                                      alpha: 0.9,
                                                    ),
                                                    Colors.white.withValues(
                                                      alpha: 0.5,
                                                    ),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        shortDate.format(summary.date),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withValues(
                                            alpha: 0.75,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: l10n.dailyBreakdown,
                  trailing: StatBadge(
                    label: l10n.days,
                    value: '${summaries.length}',
                    icon: Icons.history,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final summary = summaries[index];
                    return _HistoryDayCard(
                      summary: summary,
                      dateLabel: dateFormat.format(summary.date),
                      isRecent: index < 3,
                    );
                  }, childCount: summaries.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryDayCard extends StatefulWidget {
  const _HistoryDayCard({
    required this.summary,
    required this.dateLabel,
    required this.isRecent,
  });

  final DailyCalorieSummary summary;
  final String dateLabel;
  final bool isRecent;

  @override
  State<_HistoryDayCard> createState() => _HistoryDayCardState();
}

class _HistoryDayCardState extends State<_HistoryDayCard> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isRecent;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mealCount = widget.summary.entries.length;

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
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primary.withValues(alpha: 0.15),
                            AppTheme.accent.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: AppTheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.dateLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.mealsLoggedCount(mealCount),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.summary.totalCalories}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
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
                  ...widget.summary.entries.map(
                    (entry) => _MealHistoryRow(entry: entry),
                  ),
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
}

class _MealHistoryRow extends StatelessWidget {
  const _MealHistoryRow({required this.entry});

  final CalorieEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.description,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
                if (entry.mealType != null)
                  Text(
                    l10n.mealTypeLabel(entry.mealType),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
              ],
            ),
          ),
          Text(
            l10n.caloriesKcal(entry.calories),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
