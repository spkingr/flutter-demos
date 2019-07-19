import 'package:flutter/material.dart';
import 'package:carousel/carousel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '?',
      theme: ThemeData.light(),
      home: MyHomePage(title: 'Carousel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: new Text(widget.title),),
    body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(margin: EdgeInsets.only(top: 32.0), child: new Center(child: new Text("Android Versions", textAlign: TextAlign.center, style: Theme.of(context).textTheme.display1,)),),
          new Expanded(child: new CarouselBody()),
        ],
      ),
    ),
  );
}

class CarouselBody extends StatelessWidget{
  final _images = <String>["images/android4.jpg", "images/android5.jpg", "images/android6.jpg", "images/android7.jpg", "images/android8.jpg", ];

  @override
  Widget build(BuildContext context) => Carousel(
    displayDuration: Duration(seconds: 2),
    animationCurve: Curves.easeInOut,
    animationDuration: Duration(seconds: 1),
    children: this._images.map((name) => new Image.asset(name, fit: BoxFit.fill, alignment: Alignment.center,)).toList(),
  );
}
