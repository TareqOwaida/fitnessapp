import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthNotConfiguredException implements Exception {}

class GoogleAuthConfig {
  GoogleAuthConfig._();

  static const String _webClientIdOverride = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '',
  );

  static const String _iosClientIdOverride = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );

  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }

    final serverClientId = await resolveWebClientId();
    if (serverClientId == null || serverClientId.isEmpty) {
      throw GoogleAuthNotConfiguredException();
    }

    String? clientId;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      clientId = await resolveIosClientId();
    }

    await GoogleSignIn.instance.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );
    _initialized = true;
  }

  static Future<String?> resolveWebClientId() async {
    if (_webClientIdOverride.isNotEmpty) {
      return _webClientIdOverride;
    }
    return _readWebClientIdFromGoogleServicesJson();
  }

  static Future<String?> resolveIosClientId() async {
    if (_iosClientIdOverride.isNotEmpty) {
      return _iosClientIdOverride;
    }
    return _readPlistString(
      'ios/Runner/GoogleService-Info.plist',
      'CLIENT_ID',
    );
  }

  static Future<String?> _readWebClientIdFromGoogleServicesJson() async {
    try {
      final jsonString =
          await rootBundle.loadString('android/app/google-services.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final clients = data['client'] as List<dynamic>? ?? [];

      for (final client in clients) {
        final oauthClients =
            (client as Map<String, dynamic>)['oauth_client'] as List<dynamic>? ??
                [];
        for (final oauth in oauthClients) {
          final oauthMap = oauth as Map<String, dynamic>;
          if (oauthMap['client_type'] == 3) {
            final clientId = oauthMap['client_id'] as String?;
            if (clientId != null && clientId.isNotEmpty) {
              return clientId;
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _readPlistString(
    String assetPath,
    String key,
  ) async {
    try {
      final plist = await rootBundle.loadString(assetPath);
      final pattern = RegExp(
        '<key>$key</key>\\s*<string>([^<]+)</string>',
      );
      return pattern.firstMatch(plist)?.group(1);
    } catch (_) {}
    return null;
  }
}
