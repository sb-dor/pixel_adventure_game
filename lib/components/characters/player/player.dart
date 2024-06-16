import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure_game/components/collision/collision_bloc.dart';
import 'dart:async';
import 'package:pixel_adventure_game/pixel_adventure.dart';

import 'player_movements.dart';
import 'player_state.dart';

// you can extend "SpriteAnimation"
// but "SpriteAnimationGroupComponent" has feature to add a lot of animations

// HasGameRef feature: mixin with "HasGameRef<PixelAdventure>" means that you have references to that FlameGame widget
// because we loaded and set images in cache and we don't wanna do that again

// keyboard features: you can add keyboard feature by adding mixin "KeyboardHandler"

// collision features: you can add collision (touching features) by adding mixin "CollisionCallbacks"
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  // just a path for loading image
  final String characterPath;

  Player({required this.characterPath, super.position}) {
    // if you put debugMode to true it will show where the player is
    // otherwise there are hidden
    debugMode = true;
  }

  //
  late final SpriteAnimation idleAnimation;

  late final SpriteAnimation runningAnimation;

  final double stepTime = 0.05;

  // take a look to the image that you are loading
  // and count how many images are there
  final int countOfSpriteInImage = 11;

  PlayerMovements playerMovements = PlayerMovements.none;
  PlayerCollisionSide? collisionSide;
  double moveSpeed = 100;
  double gravity = 9.8;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  List<CollisionBloc> wallCollisions = [];
  List<CollisionBloc> groundCollisions = [];

  // onLoad runs only once like initState
  @override
  FutureOr<void> onLoad() async {
    // Add a hitbox for collision detection
    add(RectangleHitbox());
    //
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
    _applyGravity(dt);
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // debugPrint("current other thing ${other.runtimeType}");
    super.onCollision(intersectionPoints, other);
    if (other is CollisionBloc) {
      if (!other.isGround) {
        if (toRect().overlaps(other.toRect())) {
          collisionSide = _collisionSideByPlayerMovements();
          current = PlayerState.idle;
        }
      } else {
        debugPrint("bottom collision");
        collisionSide = PlayerCollisionSide.bottom;
      }
    }
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
    // doesn't matter what you will set here
    // only matters that you have to change that
    // that you could handle that
    // you can use classes either
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
        if (collisionSide == PlayerCollisionSide.left) return;
        collisionSide = PlayerCollisionSide.none;
        // if don't check is he turned to left or not he will be turning right and left forever
        if (isFacingRight) {
          // turns the sprite's face to left or right
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirx -= moveSpeed;
      case PlayerMovements.right:
        if (collisionSide == PlayerCollisionSide.right) return;
        collisionSide = PlayerCollisionSide.none;
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
      case PlayerMovements.jump:
        // other code here
        collisionSide = PlayerCollisionSide.none;
    }
    velocity = Vector2(dirx, 0.0);
    position += velocity * dt;
  }

  PlayerCollisionSide _collisionSideByPlayerMovements() {
    switch (playerMovements) {
      case PlayerMovements.left:
        return PlayerCollisionSide.left;
      case PlayerMovements.right:
        return PlayerCollisionSide.right;
      case PlayerMovements.none:
        return PlayerCollisionSide.none;
      case PlayerMovements.jump:
        return PlayerCollisionSide.none;
    }
  }

  void _applyGravity(double dt) {
    if (collisionSide == PlayerCollisionSide.bottom) return;
    velocity.y += gravity;
    // current player position
    position.y += velocity.y * dt;
  }
}
