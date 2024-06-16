import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure_game/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // removes all screen's corners thing like battery and other things
  // sets screen to full screen
  await Flame.device.fullScreen();

  // sets screen to land scape
  await Flame.device.setLandscape();

  runApp(
    GameWidget(
      game: PixelAdventure(),
    ),
  );
}
