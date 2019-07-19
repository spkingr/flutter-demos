import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

enum ButtonState{
  start,
  animation,
  loading,
  success,
  failure,
  revealing,
}

class ProgressRevealWidget extends StatefulWidget{
  ProgressRevealWidget(this.buttonText, {Key key, this.radius,
    this.duration = const Duration(milliseconds: 500), this.failureCount = 0,
    this.buttonColor = Colors.blue,
    this.successColor = Colors.green,
    this.failureColor = Colors.red,
    this.onRevealEnd, this.onRevealStart}):
        assert(buttonText != null),
        assert(radius != null && radius > 0),
        super(key: key);

  final String buttonText;
  final double radius;
  final Duration duration;

  final Color buttonColor;
  final Color successColor;
  final Color failureColor;

  final int failureCount;
  final VoidCallback onRevealStart;
  final VoidCallback onRevealEnd;

  @override
  State<ProgressRevealWidget> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressRevealWidget> with TickerProviderStateMixin{

  AnimationController _animationController;
  Animation<double> _animation;
  var _initialWidth = 0.0;
  var _width = double.infinity;
  var _state = ButtonState.start;

  var _isRevealing = false;
  var _fraction = 0.0;

  var _failureTime = 0;
  var _timeToResult = const Duration(milliseconds: 1200);
  var _timeToReveal = const Duration(milliseconds: 250);

  Timer _timer;

  Color get _buttonColor {
    Color color;
    switch(this._state){
      case ButtonState.success:
      case ButtonState.revealing:
        color = this.widget.successColor;
        break;
      case ButtonState.failure:
        color = this.widget.failureColor;
        break;
      default:
        color = this.widget.buttonColor;
        break;
    }
    return color;
  }

  @override
  void deactivate() {
    this._reset();
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    this._animationController = AnimationController(vsync: this, duration: this.widget.duration);
    this._animation = Tween(begin: 0.0, end: 1.0).animate(this._animationController)
      ..addListener((){
        if(this._state == ButtonState.animation){
          this.setState(() => this._width = this._initialWidth - this._animation.value * (this._initialWidth - this.widget.radius * 2));
        }else if(this._state == ButtonState.revealing){
          this.setState(() => this._fraction = 1.0 - this._animation.value);
        }
      })
      ..addStatusListener((status){
        switch (status){
          case AnimationStatus.completed:
            this.setState(()=>this._state = ButtonState.loading);
            this._setLoadResult();
            break;
          case AnimationStatus.dismissed:
            if(this._state == ButtonState.revealing){
              if(this.widget.onRevealEnd != null){
                this.widget.onRevealEnd();
              }
            }else{
              this.setState(()=>this._state = ButtonState.start);
            }
            break;
          default:
            break;
        }
      });
  }

  void _setLoadResult(){
    this._timer?.cancel();
    this._timer = Timer(this._timeToResult, (){
      if(this.mounted && this._state == ButtonState.loading){
        if(this._failureTime < this.widget.failureCount){
          this.setState(() => this._state = ButtonState.failure);
          this._failureTime ++;
        }else{
          this.setState(() => this._state = ButtonState.success);
          this._setTimeToReveal();
        }
      }
    });
  }

  void _setTimeToReveal(){
    Timer(this._timeToReveal, (){
      if(! this.mounted){
        return;
      }

      this.setState(() => this._isRevealing = true);
      this._state = ButtonState.revealing;
      this._animationController.reverse();

      if(this.widget.onRevealStart != null){
        this.widget.onRevealStart();
      }
    });
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    child: this._isRevealing ? null : PhysicalModel(
      color: Colors.white, //any color is ok!
      elevation: 4.0,
      borderRadius: BorderRadius.circular(this.widget.radius),
      child: Container(
        width: this._width,
        height: this.widget.radius * 2,
        child: RaisedButton(padding: const EdgeInsets.all(0.0), color: this._buttonColor, onPressed: this._onButtonPressed, child: this._buildWidget(),),
      ),
    ),
    painter: this._isRevealing ? RevealPainter(color: this._buttonColor, fraction: this._fraction, initialRadius: this.widget.radius, screenSize: MediaQuery.of(context).size) : null,
  );

  void _onButtonPressed(){
    if(this._animationController.status == AnimationStatus.forward || this._animationController.status == AnimationStatus.reverse) {
      return;
    }

    if(this._state == ButtonState.start){
      this._initialWidth = this.context.size.width;
      this._animationController.forward();
      this._state = ButtonState.animation;
    }else if(this._state == ButtonState.loading){
      this._animationController.reverse();
      this._state = ButtonState.animation;
    }else if(this._state == ButtonState.failure){
      this.setState(()=>this._state = ButtonState.loading);
      this._setLoadResult();
    }
  }

  void _reset(){
    this._state = ButtonState.start;
    this._width = this._initialWidth;
    this._isRevealing = false;
    this._failureTime = 0;
    this._fraction = 0.0;
  }

  Widget _buildWidget(){
    Widget widget;
    switch(this._state){
      case ButtonState.start:
        widget = Text(this.widget.buttonText, style: TextStyle(color: Colors.white, fontSize: 24.0),);
        break;
      case ButtonState.loading:
        widget = CircularProgressIndicator(value: null, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),);
        break;
      case ButtonState.success:
        widget = Icon(Icons.check, color: Colors.white,);
        break;
      case ButtonState.failure:
        widget = Icon(Icons.clear, color: Colors.white,);
        break;
      case ButtonState.animation:
        break;
      default:
        break;
    }
    return widget;
  }

  @override
  void dispose() {
    this._animationController.dispose();
    super.dispose();
  }
}

class RevealPainter extends CustomPainter{
  RevealPainter({this.fraction, this.color, this.initialRadius, this.screenSize});

  final Color color;
  final double fraction;
  final double initialRadius;
  final Size screenSize;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = this.color;
    var screenRadius = sqrt(this.screenSize.width * this.screenSize.width + this.screenSize.height * this.screenSize.height) / 2;
    var point = Offset(size.width / 2, size.height / 2);
    print("${screenRadius}, ${size.width / 2}, ${size.height / 2}, $fraction");
    canvas.drawCircle(point, this.initialRadius + (screenRadius - this.initialRadius) * this.fraction, paint);
  }

  @override
  bool shouldRepaint(RevealPainter oldDelegate) {
    return oldDelegate.fraction != this.fraction;
  }
}