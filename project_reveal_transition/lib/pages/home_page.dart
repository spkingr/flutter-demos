import 'package:flutter/material.dart';
import 'dart:async';
import 'package:project_reveal_transition/navigation.dart';
import '../widgets/progress_reveal_widget.dart';

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome>{
  _MyAppHomeState(){
    Navigation.initRouter();
  }

  var _text = "Click button to load, after failure once, click agian to trigger reload, and will be get success to reveal.";

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: AppBar(title: new Text("Progress Button"), leading: new Icon(Icons.radio_button_checked, color: Colors.yellow,),),
    body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //this._button,
              ProgressRevealWidget("Load", radius: 25.0, failureCount: 1, onRevealStart: this.onRevealStart,onRevealEnd : this.onRevealEnd,),
              Container(margin: const EdgeInsets.all(10.0), child: Text(this._text, textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0,),))
            ],
          ),
        )
    ),
  );

  onRevealStart(){
    this.setState(() => this._text = "Ready to reveal.");
  }

  onRevealEnd(){
    Navigation.navigateTo(this.context, "second_page");
  }

  @override
  void deactivate() {
    this._text = "Click button to load, after failure once, click agian to trigger reload, and will be get success to reveal.";
    super.deactivate();
  }
}