import 'package:flutter/material.dart';
import 'dart:math';

class FlipWidget extends StatefulWidget {
  FlipWidget({Key key, @required this.child, @required this.controller, this.perspective = 0.003, this.gap = 2.0,}):super(key: key);

  final Widget child;
  final double gap;
  final double perspective;

  final AnimationController controller;

  @override
  _FlipWidgetState createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget> with SingleTickerProviderStateMixin {

  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    this._animation = Tween(begin: pi / 2, end: 0.0).animate(CurvedAnimation(parent: this.widget.controller, curve: Curves.decelerate))
      ..addListener((){
        this.setState((){});
      });
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      ClipRect(
        child: Transform(
          transform: Matrix4.identity()..setEntry(3, 2, this.widget.perspective)..rotateX(this._animation.value),
          alignment: Alignment.bottomCenter, //FractionalOffset.center,
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.5,
            child: this.widget.child,
          ),
        ),
      ),
      Offstage(
        offstage: this.widget.gap == null || this.widget.gap <= 0.0,
        child: SizedBox(height: this.widget.gap ?? 0.0,),
      ),
      ClipRect(
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.5,
          child: this.widget.child,
        ),
      ),
    ],
  );
}