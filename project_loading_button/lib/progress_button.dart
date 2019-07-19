import 'package:flutter/material.dart';

enum ButtonState{
  start,
  animation,
  loading,
  success,
  failure,
}

class ProgressButton extends StatefulWidget{
  ProgressButton(this.buttonText, {Key key, this.radius, this.buttonColor = Colors.blue, this.successColor = Colors.green, this.failureColor = Colors.red}):
        assert(buttonText != null),
        assert(radius != null && radius > 0),
        super(key: key);

  final String buttonText;
  final double radius;

  final Color buttonColor;
  final Color successColor;
  final Color failureColor;

  final _state = new _ProgressButtonState();

  void setSuccess(){
    this._state.setSuccess();
  }
  void setFailure(){
    this._state.setFailure();
  }
  void setInitial(){
    this._state.setInitial();
  }
  ButtonState get state{
    return this._state._state;
  }

  @override
  State<StatefulWidget> createState() => this._state;
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin{

  AnimationController _animationController;
  Animation<double> _animation;
  var _initialWidth = 0.0;
  var _width = double.infinity;
  var _state = ButtonState.start;

  Color get _buttonColor {
    Color color;
    switch(this._state){
      case ButtonState.success:
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

  void setSuccess(){
    if(this._state == ButtonState.loading){
      this.setState(()=>this._state = ButtonState.success);
    }
  }

  void setFailure(){
    if(this._state == ButtonState.loading){
      this.setState(()=>this._state = ButtonState.failure);
    }
  }

  void setInitial(){
    if(this._state == ButtonState.success || this._state == ButtonState.failure){
      this._animationController.reset();
      this.setState((){
        this._state = ButtonState.start;
        this._width = this._initialWidth;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this._animationController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    this._animation = new Tween(begin: 0.0, end: 1.0).animate(this._animationController)
      ..addListener((){
        if(this._state == ButtonState.animation){
          this.setState(()=>this._width = this._initialWidth - this._animation.value * (this._initialWidth - this.widget.radius));
        }
      })
      ..addStatusListener((status){
        switch (status){
          case AnimationStatus.completed:
            this.setState(()=>this._state = ButtonState.loading);
            break;
          case AnimationStatus.dismissed:
            this.setState(()=>this._state = ButtonState.start);
            break;
          default:
            break;
        }
      });
  }

  @override
  Widget build(BuildContext context) => new PhysicalModel(
    color: Colors.white, //any color is ok!
    elevation: 4.0,
    borderRadius: new BorderRadius.circular(this.widget.radius / 2),
    child: new Container(
      width: this._width,
      height: this.widget.radius,
      child: new RaisedButton(
        padding: const EdgeInsets.all(0.0),
        color: this._buttonColor,
        onPressed: this.onButtonPressed,
        child: this.buildWidget(),
      ),
    ),
  );

  void onButtonPressed(){
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
    }
  }

  Widget buildWidget(){
    Widget widget;
    switch(this._state){
      case ButtonState.start:
        widget = new Text(this.widget.buttonText, style: new TextStyle(color: Colors.white, fontSize: 24.0),);
        break;
      case ButtonState.loading:
        widget = new CircularProgressIndicator(value: null, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),);
        break;
      case ButtonState.success:
        widget = new Icon(Icons.check, color: Colors.white,);
        break;
      case ButtonState.failure:
        widget = new Icon(Icons.clear, color: Colors.white,);
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