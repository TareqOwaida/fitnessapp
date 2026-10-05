import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui_components.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    super.key,
    required this.email,
    this.password,
  });

  final String email;
  final String? password;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _authService = AuthService();
  bool _sending = false;
  String? _message;
  bool _isSuccess = false;

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context)!;
    final password = widget.password;
    if (password == null || password.isEmpty) {
      setState(() {
        _message = l10n.signInToResend;
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _sending = true;
      _message = null;
    });

    try {
      await _authService.resendVerificationEmail(widget.email, password);
      setState(() {
        _message = l10n.verificationEmailSent;
        _isSuccess = true;
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        _message = _authService.mapAuthError(error, l10n);
        _isSuccess = false;
      });
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthScaffold(
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          AuthFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primary.withValues(alpha: 0.15),
                          AppTheme.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 42,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.checkYourInbox,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.verificationSentTo,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryDark,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.verifyEmailBeforeSignIn,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.55,
                      ),
                ),
                if (_message != null) ...[
                  const SizedBox(height: 20),
                  FeedbackBanner(
                    message: _message!,
                    isError: !_isSuccess,
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _sending ? null : _resend,
                    child: _sending
                        ? const Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text(l10n.resendVerificationEmail),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: Text(l10n.backToSignIn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
