import 'dart:ui';

import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'characters/ninja.dart';
import 'levels/demo.dart';
import 'levels/forest.dart';

import 'package:flame/flame.dart';

class NinjaWorld extends Box2DComponent {
  NinjaComponent ninja;

  NinjaWorld(Size size) : super(scale: 4.0){
    super.viewport.size = size;
  }

  void initializeWorld() {
    // add(new GroundComponent(this));
    // addAll(new DemoLevel(this).bodies);
    final demo = DemoLevel(this);
    for (var body in demo.bodies) {
      add(body);
    }
    //add(BackgroundComponent(this.viewport));
    //add(GroundComponent(this));
    add(ninja = new NinjaComponent(this));

    test();
  }

  test(){
    this.add(TestComponent(this, this.viewport));
  }

  @override
  void update(t) {
    super.update(t);
    //cameraFollow(ninja, horizontal: 0.4, vertical: 0.4);
  }

  void handleTap(Offset position) {
    print("-----$position");
    ninja.stop();
  }

  Drag handleDrag(Offset position) {
    return ninja.handleDrag(position);
  }
}
