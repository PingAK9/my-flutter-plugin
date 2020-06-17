import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../my_localize.dart';
import 'dart:convert';

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  static AppTranslationsDelegate delegate = AppTranslationsDelegate._();

  AppTranslationsDelegate._();

  @override
  bool isSupported(Locale locale) {
    try {
      MyLocalize.instance.languages
          .firstWhere((m) => m.code == locale.languageCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AppTranslations> load(Locale locale) async {
    final SharedPreferences prefInstance =
        await SharedPreferences.getInstance();
    final Locale _cache = prefInstance.containsKey(kLanguageKey)
        ? Locale(prefInstance.get(kLanguageKey))
        : locale;
    debugPrint('Load new language: ${_cache.languageCode}');
    return AppTranslations.load(_cache);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppTranslations> old) {
    return true;
  }
}

class AppTranslations {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues = {};

  AppTranslations(this.locale);

  static Future<AppTranslations> load(Locale locale) async {
    final appTranslations = AppTranslations(locale);

    final String _localeCode = locale.languageCode;

    /// Load multiple language file
    Map<dynamic, dynamic> _tmpLocale;
    final languages = MyLocalize.instance.currentLocalizeData(_localeCode);
    final path = MyLocalize.instance.path;
    for (int i = 0; i < languages.files.length; i++) {
      final String fileName = "$path${languages.files[i]}.json";
      final String jsonContent = await rootBundle.loadString(fileName);
      try {
        _tmpLocale = json.decode(jsonContent);
      } catch (e) {
        debugPrint("Load locale fail: $fileName");
      }
      _localisedValues.addAll(_tmpLocale);
    }

    return appTranslations;
  }

  String get currentLanguage => locale.languageCode;

  /// Detects if _localisedValues has the given key
  /// for translation
  bool isKeyExist(String key) => _localisedValues.containsKey(key);

  String text(String key) {
    return _localisedValues[key] ?? "$key";
  }

  String textFormat(String key, List<dynamic> replace) {
    String _value = _localisedValues[key] ?? "$key";
    for (int i = 0; i < replace.length; i++) {
      _value = _value.replaceAll("{$i}", '${replace[i]}');
    }
    return _value;
  }
}

extension BuildContextTranslations on BuildContext {
  String text(String key) {
    return Localizations.of<AppTranslations>(this, AppTranslations).text(key);
  }

  String textFormat(String key, List<dynamic> replace) {
    return Localizations.of<AppTranslations>(this, AppTranslations)
        .textFormat(key, replace);
  }

  String get currentLanguage {
    return Localizations.of<AppTranslations>(this, AppTranslations)
        .currentLanguage;
  }

  AppTranslations get appTranslation {
    return Localizations.of<AppTranslations>(this, AppTranslations);
  }
}
