import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.light(),
    home: MyAppHome(),
  );
}

class MyAppHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyAppHome();
}

class _MyAppHome extends State<MyAppHome> with TickerProviderStateMixin{
  var _portion = 0.0;
  AnimationController _animator;
  Animation<double> _animation;
  var _buttonIcon = Icons.play_arrow;

  @override
  void initState() {
    super.initState();
    this._animator = new AnimationController(duration: const Duration(milliseconds: 2000),vsync: this,);
    var curve = new CurvedAnimation(parent: this._animator, curve: Curves.easeInOut);
    this._animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() => this.setState((){ this._portion = this._animation.value; }));
    this._doAnimation();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: const Text("Animated Painter"), leading: new Icon(Icons.image, color: Colors.yellow,),),
    body: new Center(child: new Container(height: 256.0, child: new AspectRatio(aspectRatio: 1.0, child: new CustomPaint(painter: new CrossPainter(portion: this._portion, color: Colors.green, stroke: 8.0), ),)),),
    floatingActionButton: new FloatingActionButton(onPressed: this._doAnimation, child: new Icon(this._buttonIcon, color: Colors.white,),),
  );

  void _doAnimation(){
    switch(this._animator.status){
      case AnimationStatus.dismissed:
        this.setState(() => this._buttonIcon = Icons.play_arrow);
        this._animator.forward();
        break;
      case AnimationStatus.completed:
        this.setState(() => this._buttonIcon = Icons.replay);
        this._animator.reverse();
        break;
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.forward:
        break;
    }
  }

  @override
  void dispose() {
    this._animator.dispose();
    super.dispose();
  }
}

class CrossPainter extends CustomPainter{
  CrossPainter({this.portion, this.color, this.stroke}) :
        assert(portion >= 0.0 && portion <= 1.0),
        _paint = Paint()
          ..color = color
          ..strokeWidth = stroke
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.square;

  var portion = 0.0;
  var color = Colors.red;
  var stroke = 5.0;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    var radius = size.width > size.height ? size.height / 2 : size.width / 2;
    Offset start;
    Offset end;
    if(this.portion <= 0.0){
      return;
    }
    else if(this.portion <= 0.2){
      var portionLeft = this.portion;
      start = new Offset(radius * 0.4, radius * 0.4);
      end = new Offset(size.width - radius * 0.4 * 2, size.height - radius * 0.4 * 2) * portionLeft / 0.2 + start;
      canvas.drawLine(start, end, this._paint);
    }else if(this.portion <= 0.4){
      start = new Offset(radius * 0.4, radius * 0.4);
      end = new Offset(size.width - radius * 0.4, size.height - radius * 0.4);
      canvas.drawLine(start, end, this._paint);

      var portionRight = this.portion - 0.2;
      start = new Offset(size.width - radius * 0.4, radius * 0.4);
      end = new Offset(radius * 0.4 * 2 - size.width, size.height - radius * 0.4 * 2) * portionRight / 0.2 + start;
      canvas.drawLine(start, end, this._paint);
    }else{
      start = new Offset(radius * 0.4, radius * 0.4);
      end = new Offset(size.width - radius * 0.4, size.height - radius * 0.4);
      canvas.drawLine(start, end, this._paint);

      start = new Offset(size.width - radius * 0.4, radius * 0.4);
      end = new Offset(radius * 0.4, size.height - radius * 0.4);
      canvas.drawLine(start, end, this._paint);

      var portionCircle = this.portion - 0.4;
      var center = new Offset(size.width / 2, size.height / 2);
      var rect = new Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, - 3 * pi / 4 , 2 * pi * portionCircle / 0.6, false, this._paint);
    }

    /*var p1 = new Offset(radius / 3, radius / 3);
    var p2 = new Offset(size.width - radius / 3, size.height - radius / 3);
    canvas.drawLine(p1, p2, this._paint);
    p1 = new Offset(size.width - radius / 3, radius / 3);
    p2 = new Offset(radius / 3, size.height - radius / 3);
    canvas.drawLine(p1, p2, this._paint);
    var center = new Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, this._paint);*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => (oldDelegate as CrossPainter).portion != this.portion;
}
