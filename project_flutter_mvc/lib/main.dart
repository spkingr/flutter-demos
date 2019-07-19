import 'package:flutter/material.dart';

import 'package:project_flutter_mvc/mvc/mvc.dart';
import 'package:project_flutter_mvc/lib/custom_gesture.dart';
import 'package:project_flutter_mvc/lib/flip_widget.dart';
import 'package:project_flutter_mvc/lib/downloaded/flip_library.dart' as Flip;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(primarySwatch: Colors.blue,),
        home: MyMVCHomeView(new MyMVController()),
    );
  }
}

class MyMVController extends MVController{
  int counter = 0;
  String info = "Nothing happens";

  void incrementCounter(){
    this.setState(() => this.counter ++);
  }

  void setInfo(String info){
    this.setState(() => this.info += "-$info-");
  }

  void clearInfo(){
    this.setState(() => this.info = "Nothing happens");
  }
}

class MyMVCHomeView extends MCView<MyMVController>{
  MyMVCHomeView(MyMVController controller, {Key key}) : super(viewController: controller, key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Title"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.book), onPressed: () => Navigator.push(this.context, MaterialPageRoute(builder: (BuildContext context) => Flip.MyHomePage(title: "Flip",)))),
          PopupMenuButton(itemBuilder: (BuildContext context) => <PopupMenuItem>[PopupMenuItem(child: FlatButton(onPressed: this.controller.clearInfo, child: Text("Clear Text"),),)]),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.lightGreen,
                width: double.infinity,
                child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(padding: const EdgeInsets.all(8.0) , child: Text("Infomation: ${this.controller.info}", softWrap: true,)),
            ),
              ),),
            SizedBox(height: 16.0,),
            Text('You have pushed the button this many times:',),
            Text(this.controller.counter.toString(), style: Theme.of(context).textTheme.display1,),
            _TextFlipWidget((this.controller.counter).toString()),
            GestureDetector(
              onTap: () => this.controller.setInfo("you tapped text!"),
              child: Padding(padding: const EdgeInsets.all(18.0), child: Text("Custom Gesture Detector"),),
            ),
            CustomGesture(
              onTap: () => this.controller.setInfo("The parent gesture tapped!"),
              child: Container(
                color: Colors.green,
                child: Center(
                  child: CustomGesture(
                    onTap: () => this.controller.setInfo("Child gesture is tapped!"),
                    child: Opacity(child: Container(color: Colors.yellowAccent, width: 180.0, height: 200.0,), opacity: 0.75,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: this.controller.incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
}

class _TextFlipWidget extends StatefulWidget{
  _TextFlipWidget(this.text);

  final String text;

  @override
  _TexFlipWidgetState createState() => _TexFlipWidgetState();
}

class _TexFlipWidgetState extends State<_TextFlipWidget> with SingleTickerProviderStateMixin{

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    this.controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    this.controller.forward();
  }

  @override
  Widget build(BuildContext context) => FlipWidget(
    controller: this.controller,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      color: Colors.black,
      child: Text(this.widget.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 104.0, color: Colors.orange), textAlign: TextAlign.center,),
    ),
  );

  @override
  void didUpdateWidget(_TextFlipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.controller.reset();
    this.controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    this.controller.dispose();
  }
}