import 'dart:async'; // for FutureOr
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure_game/components/characters/player/player.dart';
import 'package:pixel_adventure_game/components/collision/collision_bloc.dart';

class Level extends World {
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBloc> walls = [];
  List<CollisionBloc> grounds = [];

  // onLoad runs only once like initState
  @override
  FutureOr<void> onLoad() async {
    // first add level with tile map
    level = await TiledComponent.load(
      '$levelName.tmx', // automatically sets "assets/tiles" path for us
      Vector2.all(16),
    );

    // add
    add(level);

    // set a spawn point // take a look this tutorial : https://www.youtube.com/watch?v=HrRzqV020wc
    // the name of "Spawn Point" is getting from Object Layer that we created in "Tiled" app
    final spawnPoints = level.tileMap.getLayer<ObjectGroup>("Spawn Point");

    if (spawnPoints != null) {
      for (final spawnPoint in spawnPoints.objects) {
        // we will check the name of class the we set in "Tiled" app
        switch (spawnPoint.class_) {
          case "Player":
            player.position = spawnPoint.position;
            add(player);
            break;
        }
      }
    }

    // get a collision layers like wall, ground or any other touchable layers
    // take a look this tutorial : https://www.youtube.com/watch?v=gjGwLsjIF1o
    // the name of "Collisions" is getting from Object Layer that we created in "Tiled" app
    final collisions = level.tileMap.getLayer<ObjectGroup>("Collisions");

    if (collisions != null) {
      for (final collision in collisions.objects) {
        // we will check the name of class the we set in "Tiled" app
        switch (collision.class_) {
          case "Wall":
            final wall = CollisionBloc(
              position: collision.position,
              size: collision.size,
            );
            walls.add(wall);
            // add wall as a component to see where is the collision (if you set the "debugMode" to true in collision_bloc.dart file)
            add(wall);
          case "Ground":
            final ground = CollisionBloc(
              position: collision.position,
              size: collision.size,
              isGround: true,
            );
            grounds.add(ground);
            // add wall as a component to see where is the collision (if you set the "debugMode" to true in collision_bloc.dart file)
            add(ground);
          default:
        }
      }
    }

    // pass the collisions to the player
    player.wallCollisions = walls;
    player.groundCollisions = grounds;

    return super.onLoad();
  }
}
