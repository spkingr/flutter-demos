import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'game_world.dart';

class GameRoot extends Game{
  GameRoot({this.scale, this.size}){
    this._gameWorld = GameWorld(this.scale, this.size);
    this._gameWorld.initializeWorld();

    Flame.util.addGestureRecognizer(TapGestureRecognizer()
      ..onTapDown = this._handleInput
    );
    Flame.util.addGestureRecognizer(DoubleTapGestureRecognizer()
      ..onDoubleTap = this._handleDoubleTap
    );

    this._initAssets().then((_) => this._isLoaded = true);
  }

  final Size size;
  final double scale;

  GameWorld _gameWorld;
  bool _isLoaded = false;
  int _points = 0;

  Future<Null> _initAssets() async{
    await Flame.audio.load('background.mp3');
    await Flame.audio.load('bird.aif');
    await Flame.audio.load('magical.wav');
    Flame.audio.loop('background.mp3');
  }

  @override
  void render(Canvas canvas) {
    this._gameWorld.render(canvas);

    if(this._isLoaded){
      final p = Flame.util.text(this._points.toString(), fontSize: 36.0, fontFamily: 'PressStart', color: Colors.white);
      p.paint(canvas, Offset(this.size.width - p.width - 10.0, this.size.height - p.height - 10.0));
    }
  }

  @override
  void update(double t){
    this._gameWorld.update(t);
  }

  @override
  void resize(Size size){
    this._gameWorld.resize(size);
  }

  void _handleInput(TapDownDetails details){
    this._gameWorld.handleTap(Offset(details.globalPosition.dx, details.globalPosition.dy));

    this._points ++;
    Flame.audio.play('magical.wav');
  }

  void _handleDoubleTap(){
    this._gameWorld.stopPlayer();
  }
}
