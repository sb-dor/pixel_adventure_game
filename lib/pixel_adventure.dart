import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure_game/levels/level.dart';
import 'dart:async'; // for FutureOr

class PixelAdventure extends FlameGame {

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;

  final level = Level(levelName: "Level-02");

  @override
  FutureOr<void> onLoad() async {

    // load all images into cache
    await images.loadAllImages();

    //
    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: level,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, level]);

    return super.onLoad();
  }
}
