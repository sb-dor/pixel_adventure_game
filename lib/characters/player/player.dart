import 'package:flame/components.dart';
import 'package:pixel_adventure_game/characters/player/player_state.dart';
import 'dart:async';
import 'package:pixel_adventure_game/pixel_adventure.dart';

// you can extend "SpriteAnimation"
// but "SpriteAnimationGroupComponent" has feature to add a lot of animations

// with "HasGameRef<PixelAdventure>" means that you have references to that FlameGame widget
// because we loaded and set images in cache and we don't wanna do that again
class Player extends SpriteAnimationGroupComponent with HasGameRef<PixelAdventure> {
  // just a path for loading image
  final String characterPath;

  Player({required this.characterPath, required Vector2 position})
      : super(
          position: position
        );

  //
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  final double stepTime = 0.05;

  // take a look to the image that you are loading
  // and count how many images are there
  final int countOfSpriteInImage = 11;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
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
}
