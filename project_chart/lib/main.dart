import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.light(),
    home: MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  static final _TYPE_PIE = 0;
  static final _TYPE_BAR = 1;

  var _currentClicks = 20;
  var _type = _TYPE_BAR;

  @override
  Widget build(BuildContext context) {
    var data = [new ClicksPerYear("2015", 10, Colors.redAccent), new ClicksPerYear("2016", 40, Colors.blueAccent), new ClicksPerYear("2017", this._currentClicks, Colors.lightGreen),];
    var series = [new charts.Series(id: "Clicks", data: data, domainFn: (ClicksPerYear value, _) => value.year, measureFn: (ClicksPerYear value, _) => value.clicks, colorFn: (ClicksPerYear value, _) => value.color, ), ];

    var seriesLine = [new charts.Series(id: "Clicks", data: data, domainFn: (ClicksPerYear value, _) => int.parse(value.year), measureFn: (ClicksPerYear value, _) => value.clicks, )];

    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Charts in Flutter"),
        leading: const Icon(Icons.insert_chart, color: Colors.white,),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.pie_chart, color: Colors.yellowAccent,), onPressed: () => this.setState( () => this._type = _TYPE_PIE),),
          new IconButton(icon: new Icon(Icons.insert_chart, color: Colors.yellowAccent,), onPressed: () => this.setState( () => this._type = _TYPE_BAR),),
        ],
      ),
      floatingActionButton: new FloatingActionButton(onPressed: this._onIncrementAction, child: new Icon(Icons.add, color: Colors.white,),),
      body: new Center(child: new Padding(padding: EdgeInsets.all(24.0), child: new SizedBox(height: 256.0, child: this._type == _TYPE_PIE ? new charts.PieChart<ClicksPerYear, int>(seriesLine, animate: true,) : new charts.BarChart<ClicksPerYear>(series, animate: true,), ),)), //
    );
  }

  void _onIncrementAction(){
    setState(() => this._currentClicks ++);
  }
}

class ClicksPerYear{
  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(a: color.alpha, r: color.red, g: color.green, b: color.blue,);

  final String year;
  final int clicks;
  final charts.Color color;
}