import 'game_root.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'haunt-game.dart';
import 'package:screen/screen.dart';

const double WORLD_SCALE = 1.0;

void main() async{
  Flame.initializeWidget();
  Flame.util.fullScreen();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  final size = await Flame.util.initialDimensions();
  print("__________________________________debug size: $size");

  final game = GameRoot(scale: WORLD_SCALE, size: size);
  runApp(game.widget);
}
