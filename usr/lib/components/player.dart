import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'bullet.dart';
import 'enemy.dart';
import '../game.dart';

class Player extends PositionComponent with CollisionCallbacks, HasGameRef<BattleRoyaleGame> {
  static const double speed = 200.0;
  late final JoystickComponent joystick;
  late final RectangleComponent body;

  Player({required this.joystick}) {
    size = Vector2(40, 40);
    anchor = Anchor.center;
  }

  void shoot() {
    final direction = Vector2(sin(angle), -cos(angle));

    final bullet = Bullet(
      position: position.clone() + direction * 30,
      direction: direction,
    );
    
    gameRef.world.add(bullet);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    body = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.blue,
    );
    add(body);
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      gameRef.takeDamage(10);
      other.removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * speed * dt);
      // Face the direction of movement
      angle = joystick.delta.screenAngle();
    }
    
    // Keep player within a logical bound (optional)
  }
}
