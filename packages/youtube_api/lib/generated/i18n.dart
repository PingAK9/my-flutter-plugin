import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


// Todo
class S extends WidgetsLocalizations {
  Locale _locale;
  String _lang;

  S(this._locale) {
    _lang = getLang(_locale);
  }

  static const GeneratedLocalizationsDelegate delegate =
      GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    final s = Localizations.of<S>(context, WidgetsLocalizations);
    s._lang = getLang(s._locale);
    return s;
  }

  @override
  TextDirection get textDirection => TextDirection.ltr;
}

class EN extends S {
  EN(Locale locale) : super(locale);
}

class GeneratedLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return [
       const Locale("en", ""),
    ];
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (locale, supported) {
      final languageLocale = Locale(locale.languageCode, "");
      if (supported.contains(locale)) {
        return locale;
      } else if (supported.contains(languageLocale)) {
        return languageLocale;
      } else {
        final fallbackLocale = fallback ?? supported.first;
        return fallbackLocale;
      }
    };
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    final String lang = getLang(locale);
    switch (lang) {
      case "en":
        return SynchronousFuture<WidgetsLocalizations>(EN(locale));
      default:
        return  SynchronousFuture<WidgetsLocalizations>(S(locale));
    }
  }

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

String getLang(Locale l) => l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();
