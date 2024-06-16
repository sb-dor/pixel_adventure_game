import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure_game/levels/level.dart';
import 'dart:async'; // for FutureOr

class PixelAdventure extends FlameGame {

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;

  final world = Level();

  @override
  FutureOr<void> onLoad() async {
    //
    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: world,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}
