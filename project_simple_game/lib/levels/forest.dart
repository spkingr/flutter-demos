import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/box2d/viewport.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flutter/painting.dart';
import 'package:flame/flame.dart';


class BackgroundComponent extends ParallaxComponent {
  Viewport viewport;

  BackgroundComponent(this.viewport) {
    _loadImages();
  }

  void _loadImages() {
    var filenames = new List<String>();
    for (var i = 1; i <= 6; i++) {
      filenames.add("layers/layer_0$i.png");
    }
    load(filenames);
  }

  @override
  void update(double t) {
    if (!loaded()) {
      return;
    }

    for (var i = 1; i <= 6; i++) {
      if (i <= 2) {
        updateScroll(i - 1, 0.5);
        continue;
      }
      int screens = pow(8 - i, 3);
      var scroll = viewport.getCenterHorizontalScreenPercentage(
          screens: screens.toDouble());
      updateScroll(i - 1, scroll);
    }
  }
}

const double SCALE = 4.0;

class GroundComponent extends BodyComponent {
  static final HEIGHT = 6.0;

  ParallaxRenderer parallax;
  Size size;

  GroundComponent(Box2DComponent box) : super(box) {
    this.parallax = new ParallaxRenderer("layers/layer_07_cropped.png");
  }

  @override
  void resize(Size size){
    super.resize(size);
    this.size = size;
    _createBody();
  }

  void _createBody() {
    final shape = new PolygonShape();
    shape.setAsBoxXY(this.viewport.size.width, HEIGHT);
    final fixtureDef = new FixtureDef();
    fixtureDef.shape = shape;

    var height = size.height / 2 - HEIGHT * SCALE / 2;
    print("---------------------Height: ${size.height}");

    fixtureDef.restitution = 0.0;
    fixtureDef.friction = 0.2;
    final bodyDef = new BodyDef();
    bodyDef.position = new Vector2(0.0, 0.0);//-16
    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
  }

  @override
  void update(double t) {
    if (!parallax.loaded()) {
      return;
    }

    // TODO: abstract this
    var screens = parallax.image.width / viewport.size.width / window.devicePixelRatio;
    parallax.scroll = viewport.getCenterHorizontalScreenPercentage(screens: screens); //screens~1.0
  }

  @override
  void renderPolygon(Canvas canvas, List<Offset> points) {
    if (!parallax.loaded()) {
      return;
    }

    if(! _tested){
      _test(points);
    }

    var left = 0.0;
    var top = points[3].dy;
    var right = viewport.size.width;
    var bottom = points[0].dy; //points[0].dy;
    var rect = new Rect.fromLTRB(left, top, right, bottom);
    parallax.render(canvas, rect);
  }

  var _tested = false;
  void _test(List points){
    _tested = true;
    print("---------${points.length}");
    for(var p in points){
      print("---$p");
    }
  }
}

class TestComponent extends BodyComponent {
  static final HEIGHT = 10.0;

  Size size;
  Viewport viewport;
  var isLoaded = false;

  TestComponent(Box2DComponent box, this.viewport) : super(box) {
    Flame.images.load('layers/layer_07_cropped.png').then((_){
      this.isLoaded = true;
    });
    this._createBody();
  }

  @override
  void resize(Size size){
    super.resize(size);
    this.size = size;
    print("----------1 size: ${size.width}, ${size.height}, viewport: ${viewport.size.width}, ${viewport.size.height}");
  }

  void _createBody() {
    final shape = new PolygonShape();
    shape.setAsBoxXY(200.0, HEIGHT);
    final fixtureDef = new FixtureDef();
    fixtureDef.shape = shape;

    fixtureDef.restitution = 0.0;
    fixtureDef.friction = 0.2;
    final bodyDef = new BodyDef();
    bodyDef.position = new Vector2(0.0, - this.viewport.size.height / 4 / 2 + HEIGHT / 2);// scale!
    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
  }

  @override
  void renderPolygon(Canvas canvas, List<Offset> points) {
    if (! this.isLoaded) {
      return;
    }

    if(! _tested){
      _test(points);
    }

    var left = 0.0;
    var top = 40.0;
    var right = viewport.size.width - 40; //no scale!
    //var right = points[1].dx - points[0].dx;
    var bottom = 80.0;
    var rect = new Rect.fromLTRB(left, top, right, bottom);
    //rect = new Rect.fromPoints(points[0], points[2]);
    paintImage(canvas: canvas, rect: rect, image: Flame.images.loadedFiles['layers/layer_07_cropped.png'], flipHorizontally: false, fit: BoxFit.fill);
  }

  var _tested = false;
  void _test(List points){
    _tested = true;
    print("---------1  ${points.length}");
    for(var p in points){
      print("---1  $p");
    }
  }
}