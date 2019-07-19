import 'package:flame/flame.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/viewport.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';

typedef void ComponentCallback(BodyComponent component);

class GameWorld extends Box2DComponent implements ContactListener{
  GameWorld([double scale = 1.0, Size size = Size.zero]):super(scale: scale, dimensions: size, gravity: -100.0);

  HatComponent player;
  AnimationComponent swan;
  var _isBallLoaded = false;

  var _swanDirection = -1;
  var _swanSpeed = 100.0;

  @override
  void initializeWorld() {
    this.world.setContactListener(this);

    this.add(BackgroundComponent(super.viewport));
    this.add(GroundComponent(this));
    this.player = HatComponent(this);
    this.add(this.player);

    this._createSwan().then((swan) => this.add(
        this.swan = swan
          ..x = this.viewport.size.width
          ..y = this.viewport.size.height / 3
    ));
    this._createBall().then((_){
      this._isBallLoaded = true;
    });
  }

  @override
  void update(double t) {
    super.update(t);
    //this.cameraFollow(this.player, horizontal: 0.5);

    if(this.swan != null){
      final speed = this._swanSpeed + Random().nextInt(100);
      this.swan.x += this._swanDirection * speed * t;
      if(this.swan.x < -this.swan.width){
        this._swanDirection = -1;
        this.swan.x = this.viewport.size.width + this.swan.width;
        this.swan.y = this.viewport.size.height / 3 - Random().nextInt(200);
      }else if(this.swan.x > this.viewport.size.width + this.swan.width){
        this._swanDirection = -1;
        //no use, for no flip api
      }
    }
  }

  void handleTap(Offset position){
    this.player.touchDown(position);
    if(this._isBallLoaded){
      this.add(BallComponent(this, Vector2(position.dx, position.dy), onInvisible: this._onInvisible));
    }
  }

  @override
  void beginContact(Contact contact) {
    print("1......................${contact.fixtureB.getBody().userData}, ${contact.fixtureA.getBody().userData}");
  }

  @override
  void endContact(Contact contact) {
    print("0......................${contact.fixtureB.getBody().userData}, ${contact.fixtureA.getBody().userData}");
  }

  void _onInvisible(BodyComponent ball){
    //print("----------------removed successfully!");
  }

  void stopPlayer(){
    this.player.stopMovement();
  }

  Future<Null> _createBall() async{
    await Flame.images.load("BowlingBallSprite.png");
  }

  Future<AnimationComponent> _createSwan() async{
    await Flame.images.load("SwanSheet.png");
    final width = 64.0 / super.viewport.scale;
    return AnimationComponent.sequenced(width, width, "SwanSheet.png", 8, textureWidth: 250.0, textureHeight: 250.0,);
  }

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {
  }

  @override
  void preSolve(Contact contact, Manifold oldManifold) {
  }
}

class BallComponent extends BodyComponent{
  static final double radius = 20.0;

  BallComponent(Box2DComponent box, this.position, {this.onCollision, this.onInvisible}):super(box){
    this._createBody();
  }

  final Vector2 position;
  ComponentCallback onCollision;
  ComponentCallback onInvisible;

  void _createBody() {
    final size = this.viewport.size;
    final scale = this.viewport.scale;
    final shape = CircleShape()
      ..radius = BallComponent.radius;
    shape.p.x = 0.0;
    shape.p.y = 0.0;

    final bodyDef = BodyDef()
      ..linearVelocity = Vector2(0.0, 0.0)
      ..position = Vector2(this.position.x / scale - size.width / scale / 2, size.height / 2 / scale - this.position.y / scale)
      ..bullet = true
      ..userData = "Ball"
      ..type = BodyType.DYNAMIC;

    this.body = this.world.createBody(bodyDef)
      ..createFixtureFromShape(shape, 1.0)
      ..userData = "Ball"
      ..setFixedRotation(false);
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    paintImage(
        canvas: canvas,
        image: Flame.images.loadedFiles["BowlingBallSprite.png"],
        rect: new Rect.fromCircle(center: center, radius: radius),
        fit: BoxFit.contain
    );
  }

  @override
  void update(double t) {
    super.update(t);
    if(this.body.getContactList() != null && this.onCollision != null){
      this.onCollision(this);
    }else if(this.body.position.y < /*- this.viewport.size.height / 2 - BallComponent.radius / 2*/0.0 && this.onInvisible != null){
      this.onInvisible(this);
    }
  }
}

class HatComponent extends BodyComponent{
  static final double playerHeight = 64.0;
  static final double playerWidth = 64.0;
  static final double groundHeight = 24.0;

  HatComponent(Box2DComponent box, {this.speed = 200.0,}) : super(box){
    this._loadImages().then((_) => this._isLoaded = true);
    this._createBody();
  }

  final double speed;

  bool _isLoaded = false;
  Vector2 _target;

  @override
  void update(double deltaTime) {
    if(this._target == null){
      return;
    }

    final distance = (this.body.position.x - this._target.x).abs();
    if(distance <= this.speed * deltaTime){
      this.body.position.setValues(this._target.x, this.body.position.y);
      this._target = null;
    }else{
      final direction = this._target.x > this.body.position.x ? 1 : -1;
      this.body.position.setValues(this.body.position.x + direction * this.speed * deltaTime, this.body.position.y);
    }

    var x = this.body.position.x;
    if(x <= - this.viewport.size.width / 2 + HatComponent.playerWidth / 2){
      x = - this.viewport.size.width / 2 + HatComponent.playerWidth / 2;
      this.body.position.setValues(x, this.body.position.y);
    }else if(x >= this.viewport.size.width / 2 - HatComponent.playerWidth / 2){
      x = this.viewport.size.width / 2 - HatComponent.playerWidth / 2;
      this.body.position.setValues(x, this.body.position.y);
    }

    super.update(deltaTime);
  }

  void _createBody(){
    final size = this.viewport.size;
    final scale = this.viewport.scale;
    final shape = PolygonShape()
      ..setAsBoxXY(HatComponent.playerWidth / scale / 2, HatComponent.playerHeight / scale / 2);

    final bodyDef = BodyDef()
      ..linearVelocity = Vector2.zero()
      ..position = Vector2(0.0, - size.height / scale / 2 + HatComponent.playerHeight / scale / 2 + HatComponent.groundHeight / scale)
      ..bullet = true
      ..userData = "Hat"
      ..type = BodyType.KINEMATIC;

    this.body = this.world.createBody(bodyDef)
      ..createFixtureFromShape(shape, 1.0)
      ..userData = "Hat"
      ..setFixedRotation(true);
  }

  @override
  void renderPolygon(Canvas canvas, List<Offset> points){
    if(! this._isLoaded){
      return;
    }

    //_debugPoints(points);

    var rect = Rect.fromPoints(points[0], points[2]);
    var image = Flame.images.loadedFiles["HatBackSprite.png"];
    paintImage(canvas: canvas, image: image, rect: rect, fit: BoxFit.contain);
    image = Flame.images.loadedFiles["HatFrontSprite.png"];
    paintImage(canvas: canvas, image: image, rect: rect, fit: BoxFit.contain);
  }

  /*var _isPrinted = false;
  void _debugPoints(List<Offset> points){
    if(_isPrinted){
      return;
    }
    _isPrinted = true;
    int i = 0;
    print("--------------------p-");
    points.forEach((value){
      print("-----[${i++}]: $value");
    });
    print("--------------------px");
  }*/

  void touchDown(Offset position){
    this._target = Vector2(position.dx - super.viewport.size.width / 2, super.viewport.size.height / 2 - position.dy);
  }

  void stopMovement(){
    this._target = null;
  }

  Future<Null> _loadImages() async{
    await Flame.images.load("HatBackSprite.png");
    await Flame.images.load("HatFrontSprite.png");
  }
}

class GroundComponent extends BodyComponent{
  static final double groundHeight = 128.0;

  bool _isLoaded = false;

  GroundComponent(Box2DComponent box):super(box){
    Flame.images.load("GrassSprite.png").then((_) => this._isLoaded = true);
    this._createBody();
  }

  @override
  void renderPolygon(Canvas canvas, List<Offset> points){
    if(! this._isLoaded){
      return;
    }

    final rect = Rect.fromPoints(points[0], points[2]);
    var image = Flame.images.loadedFiles["GrassSprite.png"];
    paintImage(canvas: canvas, image: image, rect: rect, fit: BoxFit.contain, repeat: ImageRepeat.repeatX);
  }

  void _createBody(){
    final size = this.viewport.size;
    final scale = this.viewport.scale;
    final shape = PolygonShape()
      ..setAsBoxXY(size.width / scale / 2, GroundComponent.groundHeight / scale / 2);

    final bodyDef = BodyDef()
      ..type = BodyType.STATIC
      ..position = Vector2(0.0, - size.height / scale / 2 + GroundComponent.groundHeight / scale / 2);

    this.body = this.world.createBody(bodyDef)
      ..createFixtureFromShape(shape)
      ..userData = "Ground";
  }
}

class BackgroundComponent extends ParallaxComponent{
  BackgroundComponent(this.viewport){
    this.load(["SkySprite.png"]);
  }

  final Viewport viewport;

  @override
  void update(double delta) {
    if(! super.loaded()){
      return;
    }

    final scroll = this.viewport.getCenterHorizontalScreenPercentage(screens: 32.0);
    this.updateScroll(0, scroll);
  }
}
