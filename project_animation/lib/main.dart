import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new MaterialApp(
    title: "?",
    theme: new ThemeData.light(),
    home: new AnimationWidget(),
  );
}

class AnimationWidget extends StatefulWidget {
  @override
  State<AnimationWidget> createState() => new _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _sizeAnimation;
  var _buttonIcon = Icons.play_arrow;

  @override
  void initState() {
    super.initState();
    this._animationController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 1000),);
    var curve = new CurvedAnimation(parent: this._animationController, curve: Curves.easeInOut);
    var tween = new Tween(begin: 0.0, end: 256.0);
    this._sizeAnimation = tween.animate(curve)
      ..addListener((){
        setState((){});
      });

    this._doAnimation();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: const Text("Animations"),),
    body: new Center(
      child: new Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(child: new Text("The alpha auto animates from 0.0 to 1.0", style: Theme.of(this.context).textTheme.title,), margin: const EdgeInsets.symmetric(vertical: 10.0),),
            new SecondAnimationWidget(),
            new Container(child: new Text("Click the button to animate the logo", style: Theme.of(this.context).textTheme.title,), margin: const EdgeInsets.symmetric(vertical: 10.0),),
            new Container(width: this._sizeAnimation.value, height: this._sizeAnimation.value, child: new Card(child: new FlutterLogo(), color: Colors.limeAccent,),),
          ],
        ),
      ),
    ),
    floatingActionButton: new FloatingActionButton(onPressed: (){this._doAnimation();}, child: new Icon(this._buttonIcon, color: Colors.white70,),),
  );

  void _doAnimation(){
    switch(this._animationController.status){
      case AnimationStatus.dismissed:
        setState((){
          this._buttonIcon = Icons.play_arrow;
        });
        this._animationController.forward();
        break;
      case AnimationStatus.completed:
        setState((){
          this._buttonIcon = Icons.replay;
        });
        this._animationController.reverse();
        break;
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.forward:
        break;
    }
  }

  @override
  void dispose() {
    this._animationController.dispose();
    super.dispose();
  }
}

class SecondAnimationWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _SecondAnimationWidget();
}

class _SecondAnimationWidget extends State<SecondAnimationWidget> with TickerProviderStateMixin{
  AnimationController _animationController;
  Animation<double> _animationSimple;

  @override
  void initState() {
    super.initState();
    this._animationController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    this._animationSimple = new Tween(begin: 0.0, end: 1.0).animate(this._animationController);

    this._animationSimple.addStatusListener((status){
      if(status == AnimationStatus.dismissed) {
        this._animationController.forward();
      }else if(status == AnimationStatus.completed) {
        this._animationController.reverse();
      }
    });

    this._animationController.forward();
  }

  @override
  Widget build(BuildContext context) => new _AnimatedComponent(animation: this._animationSimple, size: 128.0, child: this._getWidget(),);

  Widget _getWidget() => new LogoWidget();

  @override
  void dispose() {
    this._animationController.dispose();
    super.dispose();
  }
}

class _AnimatedComponent extends AnimatedWidget{
  _AnimatedComponent({Key key, Animation<double> animation, this.child, this.size}):super(key: key, listenable: animation);
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    var animation = this.listenable as Animation;
    return new AnimatedBuilder(
      animation: animation,
      builder: (_, widget) => new Opacity(opacity: animation.value, child: new Container(width: this.size, height: this.size, child: widget,),),
      child: this.child,
    );
  }
}

//No width and height specified in this widget!
class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Container(margin: const EdgeInsets.all(10.0), child: new Card(child: new Icon(Icons.favorite, color: Colors.redAccent.shade400, size: 64.0,),),);
}