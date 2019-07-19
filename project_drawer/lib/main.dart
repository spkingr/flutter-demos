import 'package:flutter/material.dart';
import 'dart:io';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.light(),
    home: MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget{
  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  final _imageHeader = "https://avatars0.githubusercontent.com/u/255900?s=460&v=4";
  final _imageBackground = "http://liuqingwen.me/upload/images/android/Android_background.png";

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Drawer App"),),
    drawer: this._getDrawer(),
    body: this._getBody(),
    floatingActionButton: FloatingActionButton(onPressed: (){} , child: Icon(Icons.home, color: Colors.white,),),
  );

  _getDrawer() => Drawer(
    elevation: 4.0,
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          onDetailsPressed: () => Navigator.of(context).pop(),
          accountName: Text("Qingwen Liu", ),
          accountEmail: Text("liuqingwen@163.com", ),
          currentAccountPicture: CircleAvatar(radius: 32.0, backgroundImage: NetworkImage(this._imageHeader), ),
          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(this._imageBackground), )),
        ),
        ListTile(title: Text("Home"), trailing: Icon(Icons.home, color: Colors.blue,), onTap: this._toHome ,),
        ListTile(title: Text("Blog"), trailing: Icon(Icons.web_asset, color: Colors.blue), onTap: this._toHome ,),
        ListTile(title: Text("Settings"), trailing: Icon(Icons.settings, color: Colors.blue), onTap: this._toHome ,),
        Divider(color: Colors.red,),
        ListTile(title: Text("Quit"), trailing: Icon(Icons.exit_to_app, color: Colors.red,), onTap: this._exitApp ,),
      ]
    ),
  );

  _getBody() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(elevation: 2.0, child: Icon(Icons.home, color: Colors.lightBlue, size: 128.0,),),
        Padding(padding: EdgeInsets.only(top: 20.0),child: Text("Drawer App", style: Theme.of(context).textTheme.display1,)),
      ],
    ),
  );

  _exitApp(){
    var dialog = SimpleDialog(
      title: Text("Alert"),
      children: <Widget>[
        Text("Are your sure to quit?", style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SimpleDialogOption(child: Text("Quit", style: TextStyle(color: Colors.red, fontSize: 18.0),), onPressed: () => Navigator.pop(this.context, true),),
            SimpleDialogOption(child: Text("Stay", style: TextStyle(color: Colors.blue, fontSize: 18.0),), onPressed: () => Navigator.pop(this.context, false),),
          ],
        ),
      ],
    );
    showDialog(context: this.context, child: dialog).then<void>((result){
      if(result){
        exit(0);
      }
    });
  }

  _toHome() => Navigator.pop(this.context);
}