import 'package:bonfire/bonfire.dart';
import 'package:darkness_fix/main.dart';
import 'package:darkness_fix/player/knight.dart';
import 'package:darkness_fix/util/game_sprite_sheet.dart';

class Spikes extends GameDecoration with Sensor<Knight> {
  final double damage;
  Knight? player;

  Spikes(Vector2 position, {this.damage = 60})
      : super.withAnimation(
          animation: GameSpriteSheet.spikes(),
          position: position,
          size: Vector2(tileSize, tileSize),
        );

  @override
  void onContact(Knight collision) {
    player = collision;
  }

  @override
  void update(double dt) {
    if (isAnimationLastFrame) {
      player?.handleAttack(AttackOriginEnum.ENEMY, damage, 0);
    }
    super.update(dt);
  }

  @override
  int get priority => LayerPriority.getComponentPriority(1);

  @override
  void onContactExit(Knight component) {
    player = null;
  }
}
