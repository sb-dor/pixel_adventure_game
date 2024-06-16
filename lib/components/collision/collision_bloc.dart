import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBloc extends PositionComponent with CollisionCallbacks {
  bool isGround;

  CollisionBloc({
    required Vector2 position,
    required Vector2 size,
    this.isGround = false,
  }) : super(
          position: position,
          size: size,
        ) {
    // if you put debugMode to true it will show where the collision is
    // otherwise there are hidden
    debugMode = true;
  }

  // RectangleHitBox or other collision detections in order detect that this is detecting with something
  // otherwise it will not work
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Add a hitBox for collision detection
    add(RectangleHitbox());
  }
}
