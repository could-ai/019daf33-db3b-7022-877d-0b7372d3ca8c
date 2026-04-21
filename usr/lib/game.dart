import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'components/player.dart';
import 'components/shoot_button.dart';
import 'components/enemy.dart';

class BattleRoyaleGame extends FlameGame with DragCallbacks, TapCallbacks, HasCollisionDetection {
  late Player player;
  late JoystickComponent joystick;
  late TextComponent healthText;

  int health = 100;
  bool isGameOver = false;
  
  double enemySpawnTimer = 0;
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add background color
    add(
      RectangleComponent(
        size: Vector2(10000, 10000),
        position: Vector2(-5000, -5000),
        paint: Paint()..color = const Color(0xFF4CAF50), // Grass green
      ),
    );

    // Setup Joystick
    final knobPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    // Setup Player
    player = Player(joystick: joystick);
    
    // Add player and camera logic
    world.add(player);
    camera.follow(player);
    
    // Add joystick to the viewport so it stays on screen
    camera.viewport.add(joystick);

    // Setup Shoot Button using a margin component to anchor to the bottom right
    final shootBtn = ShootButton(
      onPressed: () => player.shoot(),
    );
    
    final marginComponent = HudMarginComponent(
      margin: const EdgeInsets.only(right: 40, bottom: 40),
      child: shootBtn,
    );
    camera.viewport.add(marginComponent);

    // Health UI
    healthText = TextComponent(
      text: 'Health: $health',
      position: Vector2(20, 20),
    );
    camera.viewport.add(healthText);
  }

  void takeDamage(int amount) {
    if (isGameOver) return;
    health -= amount;
    healthText.text = 'Health: $health';
    
    if (health <= 0) {
      gameOver();
    }
  }

  void gameOver() {
    isGameOver = true;
    player.removeFromParent();
    
    final gameOverText = TextComponent(
      text: 'Game Over',
      position: camera.viewport.size / 2,
      anchor: Anchor.center,
      scale: Vector2.all(2.0),
    );
    camera.viewport.add(gameOverText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    enemySpawnTimer += dt;
    if (enemySpawnTimer > 2.0) { // Spawn an enemy every 2 seconds
      enemySpawnTimer = 0;
      spawnEnemy();
    }
  }

  void spawnEnemy() {
    // Spawn at a random location slightly off-screen relative to player
    final angle = random.nextDouble() * 2 * pi;
    final distance = 600.0; // Distance from player
    
    final spawnPos = player.position + Vector2(cos(angle), sin(angle)) * distance;
    
    world.add(Enemy(position: spawnPos));
  }
}
