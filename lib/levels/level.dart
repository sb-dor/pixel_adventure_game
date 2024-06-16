import 'dart:async'; // for FutureOr
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure_game/characters/player/player.dart';

class Level extends World {
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent level;

  // onLoad runs only once like initState
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      '$levelName.tmx', // automatically sets "assets/tiles" path for us
      Vector2.all(16),
    );

    add(level);

    // set a spawn point // take a look this tutorial : https://www.youtube.com/watch?v=HrRzqV020wc

    final spawnPoints = level.tileMap.getLayer<ObjectGroup>("Spawn Point");

    for (final spawnPoint in spawnPoints?.objects ?? <TiledObject>[]) {
      switch (spawnPoint.class_) {
        case "Player":
          player.position = spawnPoint.position;
          add(player);
          break;
      }
    }

    // add player component here
    // add(Player(characterPath: "Mask Dude"));

    return super.onLoad();
  }
}
