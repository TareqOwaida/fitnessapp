import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../models/user_profile.dart';
import '../services/ai_service.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import 'ui_components.dart';

class AiChatSheet extends StatefulWidget {
  const AiChatSheet({super.key, required this.user});

  final User user;

  @override
  State<AiChatSheet> createState() => _AiChatSheetState();
}

class _AiChatSheetState extends State<AiChatSheet> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _aiService = AiService();
  final _userService = UserService();

  ChatSession? _chat;
  final List<_ChatMessage> _messages = [];
  bool _sending = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    UserProfile? profile;
    try {
      profile = await _userService.streamProfile(widget.user.uid).first;
    } catch (_) {
      profile = null;
    }

    if (!mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final name = profile?.displayName.trim();
    final workoutLocation = profile?.preferredWorkoutLocation ?? 'home';
    final calorieGoal = profile?.dailyCalorieGoal ?? 2000;

    setState(() {
      _chat = _aiService.startFitnessChat(profile: profile);
      _messages.add(
        _ChatMessage(
          text: name?.isNotEmpty == true
              ? l10n.coachGreetingWithProfile(name!, calorieGoal)
              : l10n.coachGreetingDefault,
          isUser: false,
        ),
      );
      _quickPrompts = _buildQuickPrompts(
        l10n: l10n,
        workoutLocation: workoutLocation,
        calorieGoal: calorieGoal,
      );
      _loading = false;
    });
  }

  List<String> _quickPrompts = [];

  List<String> _buildQuickPrompts({
    required AppLocalizations l10n,
    required String workoutLocation,
    required int calorieGoal,
  }) {
    final locationLabel = l10n.workoutLocationLabel(workoutLocation);
    return [
      l10n.promptHighProteinBreakfast,
      l10n.promptWorkoutPlan(locationLabel),
      l10n.promptCalorieGoal(calorieGoal),
      l10n.promptRecoveryTips,
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? preset]) async {
    final text = (preset ?? _messageController.text).trim();
    if (text.isEmpty || _sending || _chat == null) {
      return;
    }

    setState(() {
      _sending = true;
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messageController.clear();
    });
    _scrollToBottom();

    final l10n = AppLocalizations.of(context)!;

    try {
      final response = await _chat!.sendMessage(Content.text(text));
      setState(() {
        _messages.add(
          _ChatMessage(text: response.text ?? l10n.noResponse, isUser: false),
        );
      });
    } catch (error) {
      setState(() {
        _messages.add(
          _ChatMessage(
            text: l10n.coachError(error.toString()),
            isUser: false,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return Container(
        height: MediaQuery.sizeOf(context).height * 0.5,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius2xl),
        ),
        child: Center(
          child: BrandedLoader(message: l10n.loadingYourCoach),
        ),
      );
    }

    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep total height (sheet + keyboard padding) within constraints.
        final sheetHeight =
            (constraints.maxHeight - keyboardInset).clamp(0.0, double.infinity) *
                0.96;

        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radius2xl),
            boxShadow: AppTheme.softShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardInset),
            child: SizedBox(
              height: sheetHeight,
              child: Column(
                children: [
                Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 12, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppTheme.heroGradient,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm + 2),
                          boxShadow: AppTheme.elevatedShadow,
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.aiCoach,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              l10n.personalizedFitnessGuidance,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.card,
                          side: const BorderSide(color: AppTheme.border),
                        ),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                if (_messages.length <= 1)
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _quickPrompts.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return QuickChip(
                          label: _quickPrompts[index],
                          onTap: _sending
                              ? null
                              : () => _sendMessage(_quickPrompts[index]),
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _ChatBubble(message: message);
                    },
                  ),
                ),
                if (_sending)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primary.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.coachIsThinking,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            decoration: InputDecoration(
                              hintText: l10n.askYourCoach,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Material(
                          color: AppTheme.primary,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm + 2),
                          child: InkWell(
                            onTap: _sending ? null : () => _sendMessage(),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm + 2),
                            child: Container(
                              width: 46,
                              height: 46,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
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
        );
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          gradient: message.isUser ? AppTheme.heroGradient : null,
          color: message.isUser ? null : AppTheme.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 6),
            bottomRight: Radius.circular(message.isUser ? 6 : 18),
          ),
          border: message.isUser ? null : Border.all(color: AppTheme.border),
          boxShadow: message.isUser
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 12,
                      color: AppTheme.primary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.coach,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary.withValues(alpha: 0.8),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : AppTheme.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}

void showAiChatSheet(
  BuildContext context, {
  required User user,
  double bottomInset = 0,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: AiChatSheet(user: user),
    ),
  );
}
