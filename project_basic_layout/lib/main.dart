import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show
  debugPaintSizeEnabled,
  debugPaintBaselinesEnabled,
  debugPaintLayerBordersEnabled,
  debugPaintPointersEnabled,
  debugRepaintRainbowEnabled;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final _theme = new ThemeData(primaryColor: Colors.lightGreen, accentColor: Colors.lightGreenAccent, primarySwatch: Colors.lightBlue,);

  @override
  Widget build(BuildContext context) => new MaterialApp(title: '?', theme: this._theme, home: new MyHomePage(title: 'Basic Layouts'),);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _message = "";

  @override
  Widget build(BuildContext context) {
    //Debug
    assert((){
      debugPaintSizeEnabled = false;
      debugPaintBaselinesEnabled = false;
      debugPaintLayerBordersEnabled = false;
      debugPaintPointersEnabled = false;
      debugRepaintRainbowEnabled = false;
      return true;
    }());

    return new Scaffold(
      appBar: new AppBar(title: new Row(children: <Widget>[new Icon(Icons.title), new Text(this.widget.title)],),),
      backgroundColor: Colors.lightBlueAccent,
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          this._buildRow1(),
          this._buildRow2(),
          this._buildRow3(),
          this._buildRow4(),
          this._buildRow5(),
          this._buildRow6(),
          this._buildRow7(),
          this._buildRow8(),
          this._buildRow9(),
        ],
      ),
      floatingActionButton: new FloatingActionButton(onPressed: (){}, child: new Icon(Icons.message, color: Colors.indigoAccent,),),
    );
  }

  void _action(String message) => setState((){this._message = message;});

  Widget _buildRow1() => new Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
    child: new Text("This is Padding: " + _message, style: new TextStyle(color: Colors.white, fontSize: 18.0), textAlign: TextAlign.center,),
  );
  Widget _buildRow2() => new Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      const Text("Row2"),
      new MaterialButton(onPressed: () {_action("You clicked the MaterialButton");}, child: const Text("MaterialButton"),),
      new RaisedButton(onPressed: () {_action("You clicked the RaisedButton");}, child: const Text("RaisedButton"),),
      new FlatButton(onPressed: (){_action("You clicked the FlatButton");}, child: const Text("FlatButton"))
    ],
  );
  Widget _buildRow3() => new Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      const Text("Row3"),
      new IconButton(icon: new Icon(Icons.favorite, color: Colors.red,), onPressed: (){_action("You clicked the IconButton");}),
      new BackButton(color: Colors.tealAccent,),
      new CloseButton(),
      new PopupMenuButton(itemBuilder: (context){
        return [new PopupMenuItem(child: const Text("Menu1")), new PopupMenuItem(child: const Text("Menu2")), new PopupMenuItem(child: const Text("Menu3")),];
      },),
      new DropdownButton(items: [new DropdownMenuItem(child: const Text("Dropdown Item 1")), new DropdownMenuItem(child: const Text("Dropdown Item 2")), new DropdownMenuItem(child: const Text("Dropdown Item 3"))], onChanged: (_){_action("DropDown Item Changed!");}),
    ],
  );
  Widget _buildRow4() => new Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      const Text("Row4"),
      new Checkbox(value: true, activeColor: Colors.cyanAccent, onChanged: (changed){_action("You clicked the Checkbox");}),
      new Radio(value: true, activeColor: Colors.amberAccent, groupValue: 0, onChanged: (changed){_action("You clicked the Radio");}),
      new Switch(value: true, activeColor: Colors.limeAccent, onChanged: (changed){_action("You clicked the Switch");}),
      new Slider(value: 80.0, min: 0.0, max: 100.0, onChanged: (changed){_action("You clicked the Slider");}),
    ],
  );
  Widget _buildRow5() => new Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Text("Row5"),
      const Text("...In Expanded..."),
      new Expanded(child:new TextField(decoration: new InputDecoration(hintText: "Type something here", enabled: true), onSubmitted: (text){this._action(text);},)),
      new Icon(Icons.bubble_chart),
    ],
  );
  Widget _buildRow6() => new Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      const Text("Row6"),
      const Text("...In SizedBox ..."),
      new SizedBox(height: 100.0, child: new Image.asset("images/flutter_logo.jpeg", fit: BoxFit.cover, color: Colors.limeAccent,),),
    ],
  );
  Widget _buildRow7() => new Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      const Text("Row7"),
      const Text("...In Card(Logo)..."),
      new Card(color: Colors.pinkAccent, elevation: 4.0, child: new FlutterLogo(size: 60.0,),),
    ],
  );
  Widget _buildRow8() => new Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      const Text("Row8"),
      new GestureDetector(
        child: new Padding(padding: const EdgeInsets.all(8.0), child: new Text("TapGestureDetector", style: new TextStyle(color: Colors.greenAccent, fontSize: 16.0),),),
        onTap: () {
          showDialog(context: this.context, child: new SimpleDialog(
            title: const Text("Simple Dialog"),
            children: <Widget>[
              new SimpleDialogOption(onPressed: (){}, child: const Text("Option 1"),),
              new SimpleDialogOption(onPressed: (){}, child: const Text("Option 2"),),
            ],
          ), );
        },
      ),
      new GestureDetector(
        child: new Padding(padding: const EdgeInsets.all(8.0), child: new Text("DoubleTapGestureDetector", style: new TextStyle(color: Colors.greenAccent,  fontSize: 16.0),),),
        onDoubleTap: (){
          showDialog(context: context, child: new AlertDialog(
            title: const Text("Alert Dialog"),
            content: new Image.asset("images/flutter_logo.jpeg"),
            actions: <Widget>[new FlatButton(onPressed: (){print("Clicks in Alert Dialog!");}, child: const Text("FlatButton", style: const TextStyle(color: Colors.red),),)],
          ),);
        },
      ),
    ],
  );
  Widget _buildRow9() => new Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      const Text("Row9"),
      new SizedBox(width: 200.0, height: 80.0, child: new Stack(fit: StackFit.loose, alignment: AlignmentDirectional.bottomCenter, children: <Widget>[
        new Image.asset("images/flutter_logo.jpeg", color: Colors.cyan,),
        const Text("Logo In Stack Of SizedBox"),
      ],),),
      new Container(child: new Center(child: const Text("Center In Container")), decoration: new BoxDecoration(color: Colors.blueGrey, borderRadius: new BorderRadius.all(new Radius.circular(16.0))), width: 120.0, height: 60.0,),
    ]
  );
}
