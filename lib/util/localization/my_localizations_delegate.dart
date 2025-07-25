import 'dart:async';

import 'package:darkness_fix/util/localization/my_localizations.dart';
import 'package:flutter/material.dart';

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pt'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) async {
    MyLocalizations localizations = MyLocalizations(locale);
    await localizations.load();
    print("Load ${locale.languageCode}");
    return localizations;
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;

  Locale resolution(Locale? locale, Iterable<Locale> supportedLocales) {
    for (Locale supportedLocale in supportedLocales) {
      if (locale != null) {
        if (supportedLocale.languageCode == locale.languageCode ||
            supportedLocale.countryCode == locale.countryCode) {
          return supportedLocale;
        }
      }
    }
    return supportedLocales.first;
  }

  static List<Locale> supportedLocales() {
    return [const Locale('en', 'US'), const Locale('pt', 'BR')];
  }
}
