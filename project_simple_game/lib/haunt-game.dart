import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:project_simple_game/ninja_world.dart';

class HauntGame extends Game {
  //Size dimensions;

  NinjaWorld ninjaWorld;

  HauntGame(Size size) {
    ninjaWorld = new NinjaWorld(size);
    ninjaWorld.initializeWorld();
    Flame.util.addGestureRecognizer(createDragRecognizer());
    Flame.util.addGestureRecognizer(createTapRecognizer());
  }

  @override
  void render(Canvas canvas) {
    ninjaWorld.render(canvas);
  }

  @override
  void update(double t) {
    ninjaWorld.update(t);
  }

  @override
  void resize(Size size) {
    ninjaWorld.resize(size);
  }

  GestureRecognizer createDragRecognizer() {
    return new ImmediateMultiDragGestureRecognizer()
      ..onStart = (Offset position) => ninjaWorld.handleDrag(position);
  }

  TapGestureRecognizer createTapRecognizer() {
    return new TapGestureRecognizer()
      ..onTapUp = (TapUpDetails details) {ninjaWorld.handleTap(details.globalPosition);};
  }
}
