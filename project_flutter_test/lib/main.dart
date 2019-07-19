import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.light(),
    home: Scaffold(
      appBar: AppBar(title: Text("Test"),),
      floatingActionButton: FloatingActionButton(onPressed: () => print("Clicked!"), child: Icon(Icons.home,),),
      body: ListView.builder(key: ValueKey("my_list_key"),itemBuilder: (BuildContext context, int index) => ListTile(title: Text("Title $index"), onTap: () => this._onTap(context),)),
    ),
  );

  void _onTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Perspective"),),
      body: PerspectiveFlutterLogoWidget(),
    )));
  }

  void _onShowPop(BuildContext context) async{
    final dialog = SimpleDialog(
      title: Text("Alert", style: Theme.of(context).textTheme.title,),
      contentPadding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Text("Verifying, please wait for a minute.", style: Theme.of(context).textTheme.subhead,),
        CounterDownWidget(onCountDown: () => this._onCountDown(context), textStyle: Theme.of(context).textTheme.subhead,),
      ],
    );

    await showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => dialog);
  }

  void _onCountDown(BuildContext context){
    Navigator.of(context).pop();
  }
}

class PerspectiveFlutterLogoWidget extends StatefulWidget{
  @override
  _PerspectiveFlutterLogoState createState() => _PerspectiveFlutterLogoState();
}

class _PerspectiveFlutterLogoState extends State<PerspectiveFlutterLogoWidget>{
  var _offset = Offset.zero;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: GestureDetector(
        onPanUpdate: this._onRotate,
        onDoubleTap: this._onReset,
        child: Transform(
          child: Card(child: FlutterLogo(size: 128.0,),),
          alignment: Alignment.center,
          transform: this._getMatrix(),
        ),
      ),
    ),
  );

  Matrix4 _getMatrix(){
    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(this._offset.dy * 0.01)
      ..rotateY(-this._offset.dx * 0.01);
    print(matrix.toString());
    return matrix;
  }

  void _onRotate(DragUpdateDetails details){
    this.setState(() => this._offset += details.delta);
  }

  void _onReset(){
    this.setState(() => this._offset = Offset.zero);
  }
}

class CounterDownWidget extends StatefulWidget{
  CounterDownWidget({this.seconds = 6, this.onCountDown, this.textStyle});

  final int seconds;
  final Function() onCountDown;
  final TextStyle textStyle;

  @override
  _CounterDownWidgetState createState() => _CounterDownWidgetState();

}

class _CounterDownWidgetState extends State<CounterDownWidget>{

  int _seconds;

  @override
  void initState() {
    super.initState();
    this._seconds = this.widget.seconds;
    Timer.periodic(const Duration(seconds: 1), (Timer timer){
      this.setState(() => this._seconds --);
      if(this._seconds <= 0){
        timer.cancel();
        if(this.widget.onCountDown != null){
          this.widget.onCountDown();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Text("${this._seconds} second${this._seconds <= 1 ? "" : "s"} left.", style: this.widget.textStyle,);
}

class Cat {
  String sound() => "Meow";
  bool eatFood(String food, {bool hungry}) => true;
  int walk(List<String> places) => 1;
  void sleep() {}
  void hunt(String place, String prey) {}
  int lives = 9;
}