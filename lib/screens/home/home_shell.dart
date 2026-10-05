import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ai_chat_sheet.dart';
import '../../widgets/onboarding_dialog.dart';
import 'calories_screen.dart';
import 'exercises_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.user});

  final User user;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _userService = UserService();
  int _index = 0;
  bool _onboardingShown = false;
  StreamSubscription<UserProfile?>? _profileSubscription;

  /// Floating nav bar height plus its bottom margin (for chat sheet inset).
  static const double bottomChromeHeight = 70 + 16;

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  Future<void> _initProfile() async {
    await _userService.ensureUserDocument(
      uid: widget.user.uid,
      email: widget.user.email ?? '',
      displayName: widget.user.displayName ?? '',
    );

    if (!mounted) {
      return;
    }

    _profileSubscription = _userService
        .streamProfile(widget.user.uid)
        .listen(_maybeShowOnboarding);
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }

  void _maybeShowOnboarding(UserProfile? profile) {
    if (profile == null ||
        profile.onboardingCompleted ||
        _onboardingShown ||
        !mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _onboardingShown) {
        return;
      }
      _onboardingShown = true;
      showOnboardingDialog(
        context,
        profile: profile,
        userService: _userService,
      );
    });
  }

  void _openAiCoach() {
    showAiChatSheet(
      context,
      user: widget.user,
      bottomInset: bottomChromeHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;

    final destinations = [
      (
        icon: Icons.restaurant_outlined,
        active: Icons.restaurant_rounded,
        label: l10n.calories,
      ),
      (
        icon: Icons.fitness_center_outlined,
        active: Icons.fitness_center_rounded,
        label: l10n.workouts,
      ),
      (
        icon: Icons.insights_outlined,
        active: Icons.insights_rounded,
        label: l10n.insights,
      ),
      (
        icon: Icons.person_outline_rounded,
        active: Icons.person_rounded,
        label: l10n.profile,
      ),
    ];

    final screens = [
      CaloriesScreen(user: widget.user),
      ExercisesScreen(user: widget.user),
      HistoryScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _index, children: screens),
          PositionedDirectional(
            top: topPadding + 8,
            end: 16,
            child: _AiCoachButton(
              label: l10n.aiCoach,
              shortLabel: l10n.ai,
              onPressed: _openAiCoach,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            border: Border.all(color: AppTheme.border.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            child: NavigationBar(
              selectedIndex: _index,
              backgroundColor: AppTheme.card,
              elevation: 0,
              height: 70,
              indicatorColor: AppTheme.primary.withValues(alpha: 0.1),
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (value) => setState(() => _index = value),
              destinations: [
                for (final dest in destinations)
                  NavigationDestination(
                    icon: Icon(dest.icon),
                    selectedIcon: Icon(dest.active),
                    label: dest.label,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AiCoachButton extends StatelessWidget {
  const _AiCoachButton({
    required this.label,
    required this.shortLabel,
    required this.onPressed,
  });

  final String label;
  final String shortLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(99),
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    shortLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
