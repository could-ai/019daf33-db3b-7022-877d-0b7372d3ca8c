import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game.dart';
import 'bullet.dart';

class Enemy extends PositionComponent with CollisionCallbacks, HasGameRef<BattleRoyaleGame> {
  static const double speed = 100.0;
  late final RectangleComponent body;

  Enemy({required Vector2 position}) : super(position: position) {
    size = Vector2(40, 40);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    body = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.red,
    );
    add(body);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move towards player
    final player = gameRef.player;
    if (!player.isRemoved) {
      final direction = (player.position - position).normalized();
      position += direction * speed * dt;
      angle = direction.screenAngle();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
    }
  }
}
