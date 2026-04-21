import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: BattleRoyaleGame(),
        ),
      ),
    ),
  );
}
