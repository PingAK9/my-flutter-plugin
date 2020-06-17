library mylocalize;

import 'dart:async';

import 'package:flutter/material.dart';
import 'src/localize_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'src/localize_data.dart';
export 'src/app_translations.dart';
export 'src/ui/language_button.dart';
export 'src/ui/language_selector_page.dart';

const String kLanguageKey = "language_code";

class WidgetLocalize extends StatelessWidget {
  const WidgetLocalize({@required this.builder});

  final AsyncWidgetBuilder<String> builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: MyLocalize.instance.onLocaleChanged.stream,
      builder: builder,
    );
  }
}

class MyLocalize {
  factory MyLocalize() => instance;

  MyLocalize._internal();

  static final MyLocalize instance = MyLocalize._internal();

  void init(
      {LocalizeData defaultLanguage,
      List<LocalizeData> languages,
      String path}) {
    this.defaultLanguage = defaultLanguage;
    this.languages = languages;
    this.languages.insert(0, defaultLanguage);
    this.path = path;
  }

  LocalizeData defaultLanguage;
  List<LocalizeData> languages;
  String path;

  LocalizeData currentLocalizeData(String code) {
    return languages.firstWhere((element) => element.code == code,
        orElse: () => defaultLanguage);
  }

  Iterable<Locale> supportedLocales() =>
      languages.map<Locale>((language) => Locale(language.code, ""));

  var onLocaleChanged = StreamController<String>.broadcast();

  /// sync change
  Future changeLanguage(String languageCode) async {
    /// save to locale
    final prefInstance = await SharedPreferences.getInstance();
    await prefInstance.setString(kLanguageKey, languageCode);

    /// set language
    onLocaleChanged.add(languageCode);
    return true;
  }
}
