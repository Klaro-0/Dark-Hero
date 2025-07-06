import 'package:darkness_fix/menu.dart';
import 'package:darkness_fix/util/localization/my_localizations_delegate.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:darkness_fix/ads_manager.dart';  // <-- import AdsManager
import 'util/sounds.dart';

double tileSize = 32;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Mobile Ads and preload one interstitial
  AdsManager.initialize();

  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

  await Sounds.initialize();

  MyLocalizationsDelegate myLocation = const MyLocalizationsDelegate();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Normal',
      ),
      home: const Menu(), // ✅ Use const for optimization
      supportedLocales: MyLocalizationsDelegate.supportedLocales(),
      localizationsDelegates: [
        myLocation,
        DefaultCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: myLocation.resolution,
    ),
  );
}