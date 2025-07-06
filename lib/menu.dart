import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:darkness_fix/game.dart';
import 'package:darkness_fix/util/custom_sprite_animation_widget.dart';
import 'package:darkness_fix/util/enemy_sprite_sheet.dart';
import 'package:darkness_fix/util/localization/strings_location.dart';
import 'package:darkness_fix/util/player_sprite_sheet.dart';
import 'package:darkness_fix/util/sounds.dart';
import 'package:darkness_fix/widgets/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:darkness_fix/ads_manager.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool showSplash = true;
  int currentPosition = 0;
  late async.Timer _timer;

  List<Future<SpriteAnimation>> sprites = [
    PlayerSpriteSheet.idleRight(),
    EnemySpriteSheet.goblinIdleRight(),
    EnemySpriteSheet.impIdleRight(),
    EnemySpriteSheet.miniBossIdleRight(),
    EnemySpriteSheet.bossIdleRight(),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showSplash = false;
      });
      startTimer();
    });
  }

  @override
  void dispose() {
    Sounds.stopBackgroundSound();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: showSplash ? buildSplash() : buildMenu(),
    );
  }

  Widget buildSplash() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/new/bg2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icon/1.png',
                  width: 120,
                ),
                const SizedBox(height: 20),
                Text(
                  'Dark Hero',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: 'Normal',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenu() {
    return Scaffold(
      body: Stack(
        children: [
          // Static background with dark overlay
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/new/bg3.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Dark Hero",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 30.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (sprites.isNotEmpty)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        key: ValueKey<int>(currentPosition),
                        height: 100,
                        width: 100,
                        child: CustomSpriteAnimationWidget(
                          animation: sprites[currentPosition],
                        ),
                      ),
                    ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(100, 40),
                      ),
                      child: Text(
                        getString('play_cap'),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 186, 89, 89),
                          fontFamily: 'Normal',
                          fontSize: 17.0,
                        ),
                      ),
                      onPressed: () {
  if (AdsManager.isAdReady) {
    AdsManager.showInterstitialAd(
      onAdClosed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Game()),
        );
      },
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Game()),
    );
  }
},

                    ),
                  ),
                  const SizedBox(height: 20),
                  DefectorRadio<bool>(
                    value: false,
                    label: 'لوحة المفاتيح',
                    group: Game.useJoystick,
                    onChange: (value) {
                      setState(() {
                        Game.useJoystick = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DefectorRadio<bool>(
                    value: true,
                    group: Game.useJoystick,
                    label: 'عصا التحكم',
                    onChange: (value) {
                      setState(() {
                        Game.useJoystick = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (!Game.useJoystick)
                    SizedBox(
                      height: 80,
                      width: 200,
                      child: Sprite.load('keyboard_tip.png').asWidget(),
                    ),
                ],
              ),
            ),
          ),

          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: 20,
                margin: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            getString('powered_by'),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Normal',
                              fontSize: 12.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL(
                                'https://www.instagram.com/yahiverse_tech/');
                            },
                            child: Text(
                              'Yakiverse_Tech',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontFamily: 'Normal',
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            getString('built_with'),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Normal',
                              fontSize: 12.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL(
                                'https://www.instagram.com/yahiverse_tech/');
                            },
                            child: Text(
                              'YAHI',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontFamily: 'Normal',
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    _timer = async.Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentPosition++;
        if (currentPosition > sprites.length - 1) {
          currentPosition = 0;
        }
      });
    });
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}