import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure_game/characters/player/player_movements.dart';
import 'package:pixel_adventure_game/characters/player/player_state.dart';
import 'dart:async';
import 'package:pixel_adventure_game/pixel_adventure.dart';

// you can extend "SpriteAnimation"
// but "SpriteAnimationGroupComponent" has feature to add a lot of animations

// HasGameRef feature: mixin with "HasGameRef<PixelAdventure>" means that you have references to that FlameGame widget
// because we loaded and set images in cache and we don't wanna do that again

// keyboard features: you can add keyboard feature by adding mixin "KeyboardHandler"
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  // just a path for loading image
  final String characterPath;

  Player({required this.characterPath, Vector2? position}) : super(position: position);

  //
  late final SpriteAnimation idleAnimation;

  late final SpriteAnimation runningAnimation;

  final double stepTime = 0.05;

  // take a look to the image that you are loading
  // and count how many images are there
  final int countOfSpriteInImage = 11;

  PlayerMovements playerMovements = PlayerMovements.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  // onLoad runs only once like initState
  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  // update function sequentially every frame
  // if your device can run about 60fps it will run 60fps or 120 -> doesn't matter
  // that is why instead of writing codes that do some animation or movements
  // better write in this function that has "Delta Time" that runs animation looking to the device's frame capabilities
  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  // onKey event is feature provided by mixin "KeyboardHandler" that wee added above
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftPressed = keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightPressed = keysPressed.contains(LogicalKeyboardKey.keyD);
    if (isLeftPressed) {
      playerMovements = PlayerMovements.left;
    } else if (isRightPressed) {
      playerMovements = PlayerMovements.right;
    } else if (isRightPressed && isLeftPressed) {
      playerMovements = PlayerMovements.none;
    } else {
      // if user is not typing anything set movement to none
      playerMovements = PlayerMovements.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  // load the spite image here
  void _loadAllAnimations() {
    idleAnimation = _loadImageFromPath("Idle", countOfSpriteInImage);
    runningAnimation = _loadImageFromPath("Run", 12);

    // list of all sprite animations
    // you have to register that
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // set current animation state
    current = PlayerState.idle;
  }

  SpriteAnimation _loadImageFromPath(String path, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/$characterPath/$path (32x32).png"),
      SpriteAnimationData.sequenced(
        amount: countOfSpriteInImage,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  // function that uses inside "update" method of component
  void _updatePlayerMovement(double dt) {
    double dirx = 0.0;
    switch (playerMovements) {
      case PlayerMovements.left:
        // if don't check is he turned to left or not he will be turning right and left forever
        if (isFacingRight) {
          // turns the sprite's face to left or right
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirx -= moveSpeed;
      case PlayerMovements.right:
        // if don't check is he turned to left or not he will be turning right and left forever
        if (!isFacingRight) {
          // turns the sprite's face to left or right
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirx += moveSpeed;
      case PlayerMovements.none:
        current = PlayerState.idle;
      // TODO: Handle this case.
    }
    velocity = Vector2(dirx, 0.0);
    position += velocity * dt;
  }
}
