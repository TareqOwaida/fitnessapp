import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app_locale';

class LocaleService extends ChangeNotifier {
  LocaleService({SharedPreferences? prefs})
      : _prefs = prefs,
        _locale = prefs != null ? _readLocale(prefs) : const Locale('en');

  SharedPreferences? _prefs;
  Locale _locale;

  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == 'ar';

  static Future<LocaleService> create() async {
    final prefs = await _loadPreferences();
    return LocaleService(prefs: prefs);
  }

  static Future<SharedPreferences?> _loadPreferences() async {
    const attempts = 3;

    for (var attempt = 0; attempt < attempts; attempt++) {
      try {
        return await SharedPreferences.getInstance();
      } on PlatformException catch (error) {
        debugPrint(
          'LocaleService: SharedPreferences unavailable (attempt ${attempt + 1}/$attempts): $error',
        );
        if (attempt < attempts - 1) {
          await Future<void>.delayed(
            Duration(milliseconds: 150 * (attempt + 1)),
          );
        }
      } catch (error) {
        debugPrint('LocaleService: SharedPreferences error: $error');
        break;
      }
    }

    return null;
  }

  Future<void> reloadSavedLocale() async {
    final prefs = await _loadPreferences();
    if (prefs == null) {
      return;
    }

    _prefs = prefs;
    final saved = _readLocale(prefs);
    if (_locale != saved) {
      _locale = saved;
      notifyListeners();
    }
  }

  static Locale _readLocale(SharedPreferences prefs) {
    final code = prefs.getString(_localeKey);
    if (code == 'ar') {
      return const Locale('ar');
    }
    return const Locale('en');
  }

  Future<SharedPreferences?> _ensurePreferences() async {
    if (_prefs != null) {
      return _prefs;
    }
    _prefs = await _loadPreferences();
    return _prefs;
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) {
      return;
    }

    _locale = locale;
    notifyListeners();

    try {
      final prefs = await _ensurePreferences();
      await prefs?.setString(_localeKey, locale.languageCode);
    } on PlatformException catch (error) {
      debugPrint('LocaleService: could not persist locale: $error');
    }
  }

  Future<void> setEnglish() => setLocale(const Locale('en'));

  Future<void> setArabic() => setLocale(const Locale('ar'));
}
