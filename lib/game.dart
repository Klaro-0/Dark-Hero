import 'package:bonfire/bonfire.dart';
import 'package:darkness_fix/decoration/door.dart';
import 'package:darkness_fix/decoration/key.dart';
import 'package:darkness_fix/decoration/potion_life.dart';
import 'package:darkness_fix/decoration/spikes.dart';
import 'package:darkness_fix/decoration/torch.dart';
import 'package:darkness_fix/enemies/boss.dart';
import 'package:darkness_fix/enemies/goblin.dart';
import 'package:darkness_fix/enemies/imp.dart';
import 'package:darkness_fix/enemies/mini_boss.dart';
import 'package:darkness_fix/interface/knight_interface.dart';
import 'package:darkness_fix/main.dart';
import 'package:darkness_fix/npc/kid.dart';
import 'package:darkness_fix/npc/wizard_npc.dart';
import 'package:darkness_fix/player/knight.dart';
import 'package:darkness_fix/util/sounds.dart';
import 'package:darkness_fix/widgets/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Game extends StatefulWidget {
  static bool useJoystick = true;
  const Game({super.key});

  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
  @override
  void initState() {
    Sounds.playBackgroundSound();
    super.initState();
  }

  @override
  void dispose() {
    Sounds.stopBackgroundSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PlayerController joystick = Joystick(
      directional: JoystickDirectional(
        spriteBackgroundDirectional: Sprite.load('joystick_background.png'),
        spriteKnobDirectional: Sprite.load('joystick_knob.png'),
        size: 100,
        isFixed: false,
      ),
      actions: [
        JoystickAction(
          actionId: 0,
          sprite: Sprite.load('joystick_atack.png'),
          spritePressed: Sprite.load('joystick_atack_selected.png'),
          size: 80,
          margin: EdgeInsets.only(bottom: 50, right: 50),
        ),
        JoystickAction(
          actionId: 1,
          sprite: Sprite.load('joystick_atack_range.png'),
          spritePressed: Sprite.load('joystick_atack_range_selected.png'),
          size: 50,
          margin: EdgeInsets.only(bottom: 50, right: 160),
        )
      ],
    );

    if (!Game.useJoystick) {
      joystick = Keyboard(
        config: KeyboardConfig(
          directionalKeys: [KeyboardDirectionalKeys.arrows()],
          acceptedKeys: [
            LogicalKeyboardKey.space,
            LogicalKeyboardKey.keyZ,
          ],
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: BonfireWidget(
        playerControllers: [
          joystick,
        ],
        player: Knight(
          Vector2(2 * tileSize, 3 * tileSize),
        ),
        map: WorldMapByTiled(
          WorldMapReader.fromAsset('tiled/map.json'),
          forceTileSize: Vector2(tileSize, tileSize),
          objectsBuilder: {
            'door': (p) => Door(p.position, p.size),
            'torch': (p) => Torch(p.position),
            'potion': (p) => PotionLife(p.position, 30),
            'wizard': (p) => WizardNPC(p.position),
            'spikes': (p) => Spikes(p.position),
            'key': (p) => DoorKey(p.position),
            'kid': (p) => Kid(p.position),
            'boss': (p) => Boss(p.position),
            'goblin': (p) => Goblin(p.position),
            'imp': (p) => Imp(p.position),
            'mini_boss': (p) => MiniBoss(p.position),
            'torch_empty': (p) => Torch(p.position, empty: true),
          },
        ),
        components: [GameController()],
        interface: KnightInterface(),
        lightingColorGame: Colors.black.withOpacity(0.6),
        backgroundColor: Colors.grey[900]!,
        cameraConfig: CameraConfig(
          speed: 3,
          zoom: getZoomFromMaxVisibleTile(context, tileSize, 18),
        ),
        // progress: Container(
        //   color: Colors.black,
        //   child: Center(
        //     child: Text(
        //       "Loading...",
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontFamily: 'Normal',
        //         fontSize: 20.0,
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
