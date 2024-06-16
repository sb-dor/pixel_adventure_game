import 'dart:io';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_adventure_game/characters/player/player.dart';
import 'package:pixel_adventure_game/characters/player/player_movements.dart';
import 'package:pixel_adventure_game/levels/level.dart';
import 'dart:async'; // for FutureOr

// in order to say to the game that some of our component will have keyboard feature
// add "HasKeyboardHandlerComponents" mixin to the main "FlameGame" widget;
// add "DragCallbacks" in order to use Joystick features
class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;

  late final JoystickComponent joystick;

  late Player player;

  late final Level level;

  late final bool showJoystick;

  // onLoad runs only once like initState
  @override
  FutureOr<void> onLoad() async {
    // load all images into cache
    showJoystick = Platform.isAndroid || Platform.isIOS;

    await images.loadAllImages();

    //

    player = Player(
      characterPath: "Mask Dude",
    );

    level = Level(
      levelName: "Level-02",
      player: player,
    );

    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: level,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, level]);

    if (showJoystick) _addJoystick();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) _updateJoystick(dt);
    super.update(dt);
  }

  void _addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Knob.png"),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Joystick.png"),
        ),
      ),
      margin: const EdgeInsets.only(
        left: 50,
        bottom: 32,
      ),
    );

    add(joystick);
  }

  void _updateJoystick(double dt) {
    switch (joystick.direction) {
      case JoystickDirection.up:
      case JoystickDirection.down:
      case JoystickDirection.idle:
        player.playerMovements = PlayerMovements.none;
      case JoystickDirection.downLeft:
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
        player.playerMovements = PlayerMovements.left;
      case JoystickDirection.right:
      case JoystickDirection.downRight:
      case JoystickDirection.upRight:
        player.playerMovements = PlayerMovements.right;
      default:
        player.playerMovements = PlayerMovements.none;
    }
  }
}
