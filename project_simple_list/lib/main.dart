import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new MaterialApp(
      title: '?',
      theme: new ThemeData(primarySwatch: Colors.blue,),
      home: new HomePage(),
    );
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _controller = new ScrollController(initialScrollOffset: 0.0);
  final String _title = "List View";
  var _dataList = _HomePage._generateData(20);

  @override
  Widget build(BuildContext context) => this._getMain(this._title);

  Widget _getMain(String title) => new Scaffold(
    key: this._scaffoldKey,
    appBar: new AppBar(title: new Text(title),),
    body: this._getList(),
    floatingActionButton: new FloatingActionButton(onPressed: (){this._scrollToTop();}, child: new Icon(Icons.arrow_upward),),
  );

  Widget _getList() => new ListView(
    controller: this._controller,
    children: this._dataList.map((data){
      return new ListTile(
        leading: new Icon(data.icon),
        title: new Text(data.name),
        subtitle: new Text(data.address),
        trailing: new Checkbox(value: data.isStar, onChanged: (changed){this._changeStar(data, changed);}, ),
        onTap: (){ this._itemSelect(data); },
      );
    }).toList(),
  );

  void _itemSelect(ListData data) {
    this._scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Row(children: <Widget>[
        new Text("Select: ${data.name}", style: new TextStyle(color: Colors.black38, fontSize: 18.0),),
        data.isStar ? new Icon(Icons.favorite, color: Colors.redAccent,) : new Text(""),
      ],),
      backgroundColor: Colors.yellowAccent,
      action: new SnackBarAction(label: "DONE", onPressed: (){ this._scaffoldKey.currentState.hideCurrentSnackBar(); },),
    ));
  }

  void _scrollToTop() {
    this._controller.jumpTo(0.0);
  }

  void _changeStar(ListData data, bool changed) {
    setState((){
      data.isStar = changed;
    });
  }

  static List<ListData> _generateData(int columns){
    columns = columns < 0 ? 0 : columns;
    var names = ["Arrow Upward", "Computer", "Bubble Chart", "Card Giftcard", "Palette",
                  "Dashboard", "Account Box", "Do Not Disturb Alt", "Favorite", "Fast Forward",
                  "G Translate", "HD", "Add Alarm", "Format Color Fill", "Leak Add"];
    var icons = [Icons.arrow_upward, Icons.computer, Icons.bubble_chart,
                  Icons.card_giftcard, Icons.palette, Icons.dashboard,
                  Icons.account_box, Icons.do_not_disturb_alt, Icons.favorite,
                  Icons.fast_forward, Icons.g_translate, Icons.hd,
                  Icons.add_alarm, Icons.format_color_fill, Icons.leak_add];
    var address = ["Beijing ", "Hunan ", "Changsha ", "Xian ", "Hangzhou " , "Zhuzhou ", "Hengyang ", "Yiyang ", "Loudi ", "Shouyang "];

    var random = new Random();
    var dataList = <ListData>[];
    for(int i = 0; i < columns; i ++) {
      var index = random.nextInt(icons.length);
      var addressRandom = new Random();
      var maxAddressLength = addressRandom.nextInt(4) + 1;
      var addressBuilder = new StringBuffer();
      for(int j = 0; j < maxAddressLength; j ++) {
        var index = addressRandom.nextInt(address.length);
        addressBuilder.write(address[index]);
      }
      addressBuilder.write("No.123-${addressRandom.nextInt(10000)}");
      var data = new ListData(name: names[index], icon: icons[index], isStar: index % 3 == 0, address: addressBuilder.toString());
      dataList.add(data);
    }
    return dataList;
  }
}

class ListData
{
  ListData({this.icon = Icons.people, this.name = "Unknown", this.address = "Unknown address", this.isStar = false});
  IconData icon;
  String name;
  String address;
  bool isStar;
}

