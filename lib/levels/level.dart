import 'dart:async'; // for FutureOr
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      'Level-01.tmx', // automatically sets "assets/tiles" path for us
      Vector2.all(16),
    );

    add(level);

    return super.onLoad();
  }
}