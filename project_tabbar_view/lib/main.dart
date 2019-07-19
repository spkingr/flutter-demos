import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "?",
      color: Colors.lightBlue,
      theme: new ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrangeAccent,
      ),
      home: new _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  final _tabData = <TabData>[
    const TabData(title: "Smart Phone", icon: Icons.smartphone),
    const TabData(title: "Old Phone", icon: Icons.phone),
    const TabData(title: "Computer", icon: Icons.computer),
    const TabData(title: "Watch", icon: Icons.watch),
    const TabData(title: "Mouse", icon: Icons.mouse),
    const TabData(title: "Home", icon: Icons.home),
  ];

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: this._tabData.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text("Tabbar View"),
            bottom: new TabBar(
              isScrollable: true,
              labelColor: Colors.white,
              tabs: this._tabData.map((data){return new Tab(text: data.title, icon: new Icon(data.icon, color: Colors.limeAccent,),);}).toList(),
            ),
          ),
          body: new TabBarView(children: this._tabData.map((data){
            return new Center(child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(data.icon, color: Colors.black38, size: 180.0,),
                new Container(width: 128.0, height: 16.0, decoration: new BoxDecoration(color: Colors.cyan, borderRadius: const BorderRadius.all(const Radius.circular(4.0))),),
                new Text("You take the: ${data.title}.", textAlign: TextAlign.center, style: new TextStyle(color: Colors.redAccent, fontSize: 24.0,),),
              ],
            ),);
          }).toList(),),
          floatingActionButton: new FloatingActionButton(onPressed: () {}, elevation: 4.0, child: new Icon(Icons.favorite, color: Colors.yellowAccent,),),
        ));
  }
}

class TabData {
  const TabData({this.icon, this.title});

  final IconData icon;
  final String title;
}
