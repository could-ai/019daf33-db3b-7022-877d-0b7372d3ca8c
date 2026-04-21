import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bullet extends PositionComponent {
  static const double speed = 500.0;
  final Vector2 direction;
  late final CircleComponent body;
  double distanceTraveled = 0;
  static const double maxDistance = 1000;

  Bullet({
    required Vector2 position,
    required this.direction,
  }) : super(position: position) {
    size = Vector2(8, 8);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    body = CircleComponent(
      radius: 4,
      paint: Paint()..color = Colors.yellow,
    );
    add(body);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    final delta = direction * speed * dt;
    position.add(delta);
    
    distanceTraveled += delta.length;
    if (distanceTraveled > maxDistance) {
      removeFromParent();
    }
  }
}
