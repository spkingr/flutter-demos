import 'package:flutter/material.dart';
import '../navigation.dart';
import 'page_text_field.dart';
import 'page_scrollable_Tabs.dart';
import 'page_backdrop.dart';

class HomePage extends StatefulWidget{

  static const PAGE_NAME = "/";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Home"), leading: const Icon(Icons.home, color: Colors.yellow,),),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(margin: const EdgeInsets.symmetric(vertical: 10.0),child: OutlineButton(color: Colors.green, textColor: Colors.purpleAccent, onPressed: () => Navigation.navigateTo(context, TextFieldPage.PAGE_NAME,), child: const Text("Text Field"),)),
            Container(margin: const EdgeInsets.symmetric(vertical: 10.0),child: OutlineButton(color: Colors.blue, textColor: Colors.orange, onPressed: () => Navigation.navigateTo(context, ScrollableTabsPage.PAGE_NAME,), child: const Text("Scrollable Tabs"),)),
            Container(margin: const EdgeInsets.symmetric(vertical: 10.0),child: OutlineButton(color: Colors.yellow, textColor: Colors.redAccent, onPressed: () => Navigation.navigateTo(context, BackdropPage.PAGE_NAME,), child: const Text("Backup"),)),
            Text("Click the outline buttons make navigations to other pages.", style: Theme.of(this.context).textTheme.body2,),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.home, color: Colors.white,),),
  );
}