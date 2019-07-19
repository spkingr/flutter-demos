import 'package:flutter/material.dart';
import 'progress_button.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) => new MaterialApp(
    title: "?",
    theme: new ThemeData.light(),
    home: new MyAppHome(),
  );
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome>{
  var _state = 0;
  var _title = "Click button to load (while loading, click button to cancel), and click the floating button to make the result failure.";
  var _icon = Icons.clear;
  var _button = new ProgressButton("Load", radius: 50.0,);

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: new Text("Progress Button"), leading: new Icon(Icons.radio_button_checked, color: Colors.yellow,),),
    body: new Center(
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              this._button,
              new Container(margin: const EdgeInsets.all(10.0), child: new Text(this._title, textAlign: TextAlign.center, style: new TextStyle(fontSize: 18.0,),))
            ],
          ),
        )
    ),
    floatingActionButton: new FloatingActionButton(onPressed: this.onButtonClick, child: new Icon(this._icon, color: Colors.white,),),
  );

  void onButtonClick(){
    this.setState((){
      if(this._state == 0 && this._button.state == ButtonState.loading){
        this._state = 1;
        this._title = "Load failed, click button to reload.";
        this._icon = Icons.check;
        this._button.setFailure();
      }else if(this._state == 1 && this._button.state == ButtonState.loading){
        this._state = 2;
        this._title = "Load success! click the floating button to reset.";
        this._icon = Icons.rotate_left;
        this._button.setSuccess();
      }else{
        this._state = 0;
        this._title = "Click button to load, and click the floating button to make the result failure.";
        this._icon = Icons.clear;
        this._button.setInitial();
      }
    });
  }
}