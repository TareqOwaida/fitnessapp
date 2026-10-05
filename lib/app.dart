import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_shell.dart';
import 'services/locale_service.dart';
import 'theme/app_theme.dart';
import 'widgets/connectivity_banner.dart';
import 'widgets/ui_components.dart';

class FitenneApp extends StatelessWidget {
  const FitenneApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = context.watch<LocaleService>();

    return MaterialApp(
      title: 'Fitenne',
      debugShowCheckedModeBanner: false,
      locale: localeService.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(localeService.locale),
      builder: (context, child) {
        return Stack(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: ConnectivityBanner(),
            ),
            ?child,
          ],
        );
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final l10n = AppLocalizations.of(context)!;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: DecoratedBox(
                decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FitenneLogo(size: 80, showGlow: true),
                      const SizedBox(height: 32),
                      Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 36,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.appTagline,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final user = snapshot.data;
          if (user == null || !user.emailVerified) {
            return const LoginScreen();
          }

          return HomeShell(user: user);
        },
      ),
    );
  }
}
