import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ShootButton extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;
  late final CircleComponent body;

  ShootButton({
    required this.onPressed,
  }) : super() {
    size = Vector2(80, 80);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    body = CircleComponent(
      radius: 40,
      paint: Paint()..color = Colors.red.withOpacity(0.8),
    );
    add(body);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
  }
}
