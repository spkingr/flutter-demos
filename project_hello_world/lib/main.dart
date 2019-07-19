import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      title: "?",
      theme: new ThemeData(primaryColor: Colors.blue, accentColor: Colors.amberAccent),
      home: new MyWidget(),
    ));

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(title: new Text("Hello World App"),),
        body: new HelloWorldWidget(),
      );
}

class HelloWorldWidget extends StatefulWidget {
  @override
  State<HelloWorldWidget> createState() => new _HelloWorldWidgetSate();
}

class _HelloWorldWidgetSate extends State<HelloWorldWidget> {
  var _text = "Hello World";
  var _count = 0;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(_text,),

          new Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new MaterialButton(
              onPressed: () {
                setState(() {
                  _count++;
                  _text = "Hello World With $_count Time${_count > 1 ? "s" : ""}";
                });
              },
              child: new Text("Hello World"),
              textColor: Colors.deepOrange,
            ),
          ),

          new Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new MaterialButton(
              onPressed: () {
                if (_count != 0) {
                  setState(() {
                    _count = 0;
                    _text = "Hello World";
                  });
                }
              },
              child: new Text("Hello World Again"),
              textColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
