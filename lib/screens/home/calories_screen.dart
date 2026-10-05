import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_extensions.dart';
import '../../models/calorie_entry.dart';
import '../../models/user_profile.dart';
import '../../services/ai_service.dart';
import '../../services/calorie_service.dart';
import '../../services/locale_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/meal_confirm_dialog.dart';
import '../../widgets/ui_components.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({super.key, required this.user});

  final User user;

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  final _foodController = TextEditingController();
  final _scrollController = ScrollController();
  final _calorieService = CalorieService();
  final _userService = UserService();
  final _aiService = AiService();
  final _imagePicker = ImagePicker();
  final _speech = stt.SpeechToText();

  List<stt.LocaleName>? _speechLocales;
  bool _analyzing = false;
  bool _listening = false;
  bool _speechAvailable = false;
  bool _speechInitAttempted = false;
  bool _speechInitializing = false;
  String? _error;
  Uint8List? _selectedImageBytes;
  String? _selectedImageMimeType;

  Future<bool> _ensureSpeechReady() async {
    if (_speechAvailable) {
      return true;
    }
    if (_speechInitAttempted) {
      return false;
    }

    setState(() => _speechInitializing = true);

    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) {
              setState(() => _listening = false);
            }
          }
        },
        onError: (_) {
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            setState(() {
              _listening = false;
              _error = l10n.voiceInputFailed;
            });
          }
        },
      );
      if (available) {
        _speechLocales = await _speech.locales();
      }
      if (mounted) {
        setState(() {
          _speechAvailable = available;
          _speechInitAttempted = true;
          _speechInitializing = false;
        });
      }
      return available;
    } on MissingPluginException {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _speechAvailable = false;
          _speechInitAttempted = true;
          _speechInitializing = false;
          _error = l10n.voiceInputRestartLong;
        });
      }
      return false;
    } on PlatformException {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _speechAvailable = false;
          _speechInitAttempted = true;
          _speechInitializing = false;
          _error = l10n.voiceInputUnavailable;
        });
      }
      return false;
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _speechAvailable = false;
          _speechInitAttempted = true;
          _speechInitializing = false;
          _error = l10n.voiceInputCouldNotStart;
        });
      }
      return false;
    }
  }

  Future<void> _stopSpeech() async {
    try {
      await _speech.stop();
    } on MissingPluginException {
      // Plugin not linked — nothing to stop.
    } on PlatformException {
      // Ignore stop errors during teardown.
    }
  }

  @override
  void dispose() {
    _stopSpeech();
    _foodController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageMimeType = _mimeTypeForPath(image.path);
        _error = null;
      });
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() => _error = l10n.couldNotLoadImage('$error'));
      }
    }
  }

  String _mimeTypeForPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) {
      return 'image/png';
    }
    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }
    if (lower.endsWith('.heic') || lower.endsWith('.heif')) {
      return 'image/heic';
    }
    return 'image/jpeg';
  }

  Future<void> _toggleVoiceInput() async {
    if (_analyzing || _speechInitializing) {
      return;
    }

    if (_listening) {
      await _stopSpeech();
      if (mounted) {
        setState(() => _listening = false);
      }
      return;
    }

    final appLocale = context.read<LocaleService>().locale;

    if (!await _ensureSpeechReady()) {
      return;
    }

    setState(() {
      _listening = true;
      _error = null;
    });

    final localeId = _resolveSpeechLocaleId(appLocale, _speechLocales ?? []);

    try {
      await _speech.listen(
        onResult: (result) {
          if (!mounted) {
            return;
          }
          setState(() {
            _foodController.text = result.recognizedWords;
            _foodController.selection = TextSelection.fromPosition(
              TextPosition(offset: _foodController.text.length),
            );
          });
        },
        listenOptions: stt.SpeechListenOptions(
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
          localeId: localeId,
        ),
      );
    } on MissingPluginException {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _listening = false;
          _speechAvailable = false;
          _error = l10n.voiceInputRestartLong;
        });
      }
    } on PlatformException {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _listening = false;
          _error = l10n.microphoneDenied;
        });
      }
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageMimeType = null;
    });
  }

  bool get _canLog =>
      _foodController.text.trim().isNotEmpty || _selectedImageBytes != null;

  Future<void> _logFood() async {
    final description = _foodController.text.trim();
    final hasImage = _selectedImageBytes != null;
    if (!_canLog) {
      return;
    }

    if (_listening) {
      await _stopSpeech();
    }

    setState(() {
      _analyzing = true;
      _listening = false;
      _error = null;
    });

    try {
      final profile = await _userService.streamProfile(widget.user.uid).first;
      final todayEntries =
          await _calorieService.streamTodayEntries(widget.user.uid).first;
      final consumedToday = todayEntries.fold<int>(
        0,
        (sum, entry) => sum + entry.calories,
      );

      final CalorieAnalysis analysis;
      if (hasImage) {
        analysis = await _aiService.analyzeFoodImage(
          _selectedImageBytes!,
          _selectedImageMimeType ?? 'image/jpeg',
          description: description.isNotEmpty ? description : null,
          profile: profile,
          caloriesConsumedToday: consumedToday,
        );
      } else {
        analysis = await _aiService.analyzeFood(
          description,
          profile: profile,
          caloriesConsumedToday: consumedToday,
        );
      }

      if (!mounted) {
        return;
      }

      final l10n = AppLocalizations.of(context)!;
      final entryDescription = description.isNotEmpty
          ? description
          : (analysis.description?.trim().isNotEmpty == true
              ? analysis.description!.trim()
              : l10n.mealFromPhoto);

      setState(() => _analyzing = false);

      final confirmed = await showMealConfirmDialog(
        context,
        description: entryDescription,
        calories: analysis.calories,
        mealType: analysis.mealType,
        notes: analysis.notes,
        imageBytes: hasImage ? _selectedImageBytes : null,
      );

      if (!confirmed || !mounted) {
        return;
      }

      final now = DateTime.now();

      await _calorieService.addEntry(
        CalorieEntry(
          id: '',
          userId: widget.user.uid,
          description: entryDescription,
          calories: analysis.calories,
          date: now,
          createdAt: now,
          mealType: analysis.mealType,
          aiNotes: analysis.notes,
        ),
      );

      _foodController.clear();
      _clearImage();
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
          );
        }
      });
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() => _error = l10n.couldNotAnalyzeFood('$error'));
      }
    } finally {
      if (mounted) {
        setState(() => _analyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todayLabel = DateFormat(
      'EEEE, MMM d',
      Localizations.localeOf(context).toString(),
    ).format(DateTime.now());

    return Scaffold(
      body: StreamBuilder<UserProfile?>(
        stream: _userService.streamProfile(widget.user.uid),
        builder: (context, profileSnapshot) {
          final goal = profileSnapshot.data?.dailyCalorieGoal ?? 2000;

          return StreamBuilder<List<CalorieEntry>>(
            stream: _calorieService.streamTodayEntries(widget.user.uid),
            builder: (context, snapshot) {
              final profileLoading =
                  profileSnapshot.connectionState == ConnectionState.waiting &&
                  !profileSnapshot.hasData;
              final entriesLoading =
                  snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData;
              final loading = profileLoading || entriesLoading;
              final streamError = snapshot.hasError ? '${snapshot.error}' : null;
              final entries = snapshot.data ?? [];
              final total = entries.fold<int>(
                0,
                (sum, item) => sum + item.calories,
              );
              final remaining = (goal - total).clamp(0, goal);
              final progress =
                  goal > 0 ? (total / goal).clamp(0.0, 1.0) : 0.0;

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  GradientHeader(
                    title: l10n.todaysCalories,
                    subtitle: todayLabel,
                    expandedHeight: 132,
                  ),
                  SliverToBoxAdapter(child: _buildInputSection()),
                  SliverToBoxAdapter(
                    child: _CalorieSummaryCard(
                      total: total,
                      goal: goal,
                      remaining: remaining,
                      progress: progress,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: l10n.mealsToday,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      trailing: StatBadge(
                        label: l10n.logged,
                        value: '${entries.length}',
                        icon: Icons.restaurant_rounded,
                      ),
                    ),
                  ),
                  if (streamError != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: FeedbackBanner(
                          message: l10n.couldNotLoadMeals(streamError),
                        ),
                      ),
                    ),
                  if (loading)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: BrandedLoader(message: l10n.loadingYourMeals),
                        ),
                      ),
                    )
                  else if (entries.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        child: EmptyStateView(
                          icon: Icons.restaurant_menu_rounded,
                          title: l10n.noMealsLoggedYet,
                          message: l10n.noMealsLoggedHint,
                          action: QuickChip(
                            label: l10n.dailyGoalKcal(goal),
                            icon: Icons.flag_outlined,
                            selected: true,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _AnimatedMealCard(
                            key: ValueKey(entries[index].id),
                            entry: entries[index],
                            index: index,
                          ),
                          childCount: entries.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInputSection() {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const IconBadge(
                  icon: Icons.auto_awesome_rounded,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.logAMeal,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        l10n.logAMealSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (_selectedImageBytes != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                child: Stack(
                  children: [
                    Image.memory(
                      _selectedImageBytes!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: _analyzing ? null : _clearImage,
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _foodController,
              minLines: 2,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _analyzing || !_canLog ? null : _logFood(),
              decoration: InputDecoration(
                labelText: l10n.whatDidYouEat,
                hintText: _listening
                    ? l10n.listeningDescribeMeal
                    : l10n.mealHintExample,
                suffixIcon: _foodController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _foodController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InputActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: l10n.camera,
                  onPressed: _analyzing ? null : () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 8),
                _InputActionButton(
                  icon: Icons.photo_library_rounded,
                  label: l10n.gallery,
                  onPressed: _analyzing ? null : () => _pickImage(ImageSource.gallery),
                ),
                const SizedBox(width: 8),
                if (!kIsWeb)
                  _InputActionButton(
                    icon: _speechInitializing
                        ? Icons.hourglass_empty_rounded
                        : _listening
                            ? Icons.mic_rounded
                            : Icons.mic_none_rounded,
                    label: _speechInitializing
                        ? '...'
                        : _listening
                            ? l10n.stop
                            : l10n.voice,
                    selected: _listening,
                    onPressed: _analyzing || _speechInitializing
                        ? null
                        : _toggleVoiceInput,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _analyzing
                  ? _AnalyzingButton(
                      key: const ValueKey('analyzing'),
                      hasImage: _selectedImageBytes != null,
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const ValueKey('idle'),
                        onPressed: _canLog ? _logFood : null,
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: Text(
                          _selectedImageBytes != null
                              ? l10n.analyzePhotoAndLog
                              : l10n.analyzeAndLog,
                        ),
                      ),
                    ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: FeedbackBanner(message: _error!),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalorieSummaryCard extends StatelessWidget {
  const _CalorieSummaryCard({
    required this.total,
    required this.goal,
    required this.remaining,
    required this.progress,
  });

  final int total;
  final int goal;
  final int remaining;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final overGoal = total > goal;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animatedProgress, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: overGoal
                    ? [AppTheme.accentWarm, const Color(0xFFE65100)]
                    : [AppTheme.primary, AppTheme.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: (overGoal ? Colors.orange : AppTheme.primary)
                      .withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: CircularProgressIndicator(
                          value: animatedProgress,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: total),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) => Text(
                              '$value',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            l10n.kcal,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overGoal ? l10n.overDailyGoal : l10n.onTrack,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.totalOfGoalKcal(total, goal),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _StatChip(
                            label: l10n.remaining,
                            value: '$remaining',
                            icon: Icons.trending_down,
                          ),
                          const SizedBox(width: 8),
                          _StatChip(
                            label: l10n.goal,
                            value: '$goal',
                            icon: Icons.flag_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.9)),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedMealCard extends StatefulWidget {
  const _AnimatedMealCard({
    super.key,
    required this.entry,
    required this.index,
  });

  final CalorieEntry entry;
  final int index;

  @override
  State<_AnimatedMealCard> createState() => _AnimatedMealCardState();
}

class _AnimatedMealCardState extends State<_AnimatedMealCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mealStyle = _mealStyle(widget.entry.mealType);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: PremiumCard(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 12),
          borderRadius: AppTheme.radiusMd + 2,
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
                  child: Icon(mealStyle.icon, color: mealStyle.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entry.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _MealTypeTag(
                            label: l10n.mealTypeLabel(widget.entry.mealType),
                            color: mealStyle.color,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.schedule_rounded,
                            size: 12,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat.jm(
                              Localizations.localeOf(context).toString(),
                            ).format(widget.entry.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                      if (widget.entry.aiNotes != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.entry.aiNotes!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                height: 1.4,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: mealStyle.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.entry.calories}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: mealStyle.color,
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}

class _MealTypeTag extends StatelessWidget {
  const _MealTypeTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
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

class _InputActionButton extends StatelessWidget {
  const _InputActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected
            ? AppTheme.primary.withValues(alpha: 0.12)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(
                color: selected ? AppTheme.primary : AppTheme.border,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? AppTheme.primary : AppTheme.textSecondary,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppTheme.primary : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalyzingButton extends StatelessWidget {
  const _AnalyzingButton({super.key, this.hasImage = false});

  final bool hasImage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            hasImage
                ? l10n.recognizingFoodInPhoto
                : l10n.analyzingWithAi,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealStyle {
  const _MealStyle({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}

_MealStyle _mealStyle(String? mealType) {
  final type = (mealType ?? '').toLowerCase();
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

String? _resolveSpeechLocaleId(Locale appLocale, List<stt.LocaleName> available) {
  final lang = appLocale.languageCode.toLowerCase();

  String normalize(String id) => id.toLowerCase().replaceAll('_', '-');

  if (appLocale.countryCode != null && appLocale.countryCode!.isNotEmpty) {
    final preferred = '$lang-${appLocale.countryCode!.toUpperCase()}';
    for (final locale in available) {
      if (normalize(locale.localeId) == preferred.toLowerCase()) {
        return locale.localeId;
      }
    }
  }

  for (final locale in available) {
    final id = normalize(locale.localeId);
    if (id == lang || id.startsWith('$lang-')) {
      return locale.localeId;
    }
  }

  if (lang == 'ar') {
    return 'ar-SA';
  }
  if (lang == 'en') {
    return 'en-US';
  }

  return null;
}
