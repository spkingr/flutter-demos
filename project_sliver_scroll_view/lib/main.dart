import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: MyHomePage(),
    );
}

class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _controller;
  var _isExpanded = true;

  @override
  void initState() {
    this._controller = ScrollController()
      ..addListener((){
        if(!this._isExpanded && this._controller.offset <= 0.0){
          this.setState(() => this._isExpanded = true);
        }else if(this._isExpanded && this._controller.offset > 0.0){
          this.setState(() => this._isExpanded = false);
        }
        //print("${this._controller.position} + ${this._controller.offset}");
      }
    );
    super.initState();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      controller: this._controller,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          //title: const Text("Title"),
          centerTitle: true,
          pinned: true,
          leading: Icon(Icons.home, color: Colors.white,),
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: Text("FlexibleSpaceBar"),
              decoration: this._isExpanded ? BoxDecoration(color: Colors.grey.shade200.withAlpha(64), borderRadius: new BorderRadius.all(const Radius.circular(4.0))) : null,
            ),
            centerTitle: false,
            background: Image.asset("images/background.png", fit: BoxFit.cover,),
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.access_time, color: Colors.white,), onPressed: () {},),
            IconButton(icon: Icon(Icons.account_balance, color: Colors.white,), onPressed: () {},),
            PopupMenuButton<int>(
              onSelected: (value) => print("Selection[$value] in popup menu."),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                PopupMenuItem(value: 1, child: Icon(Icons.work, color: Colors.green,),),
                PopupMenuDivider(),
                PopupMenuItem(value: 2, child: Icon(Icons.settings_backup_restore, color: Colors.red,),),
                PopupMenuDivider(),
                PopupMenuItem(value: 3, child: Icon(Icons.settings, color: Colors.blue,),),
              ],
            ),
          ],
        ),
        SliverPadding(padding: const EdgeInsets.symmetric(vertical: 4.0),),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            Container(color: Colors.greenAccent, padding: const EdgeInsets.symmetric(vertical: 4.0) ,alignment: Alignment.center, child: Text("List Item", style: Theme.of(context).textTheme.headline,),),
            Container(color: Colors.cyanAccent, padding: const EdgeInsets.symmetric(vertical: 4.0) ,alignment: Alignment.center, child: Text("In Sliver Appbar", style: Theme.of(context).textTheme.headline,),),
            Container(color: Colors.lightGreenAccent, padding: const EdgeInsets.symmetric(vertical: 4.0) ,alignment: Alignment.center, child: Text("Of Custom Scroll View", style: Theme.of(context).textTheme.headline,),),
            Container(color: Colors.limeAccent, padding: const EdgeInsets.symmetric(vertical: 4.0) ,alignment: Alignment.center, child: Text("The Sliver List Items", style: Theme.of(context).textTheme.headline,),),
            Container(color: Colors.yellow, padding: const EdgeInsets.symmetric(vertical: 4.0) ,alignment: Alignment.center, child: Text("In Sliver Child List Delegate", style: Theme.of(context).textTheme.headline,),),
          ]),
        ),
        SliverPadding(padding: const EdgeInsets.symmetric(vertical: 4.0),),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200.0, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0, childAspectRatio: 2.0,),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => Container(
              margin: EdgeInsets.only(left: (index + 1) % 2 * 4.0, right: index % 2 * 4.0),
              alignment: Alignment.center,
              color: Colors.teal[100 * (index % 9) + 100],
              child: Text("Grid Item $index"),
            ),
            childCount: 10,
          ),
        ),
        SliverPadding(padding: const EdgeInsets.symmetric(vertical: 4.0),),
        SliverFixedExtentList(
          itemExtent: 100.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => Container(
              alignment: Alignment.center,
              color: Colors.blue[100 * (index % 9) + 100],
              child: Text("Infinity Grid Item $index"),
            ),
          ),
        ),
      ],
    ),
  );
}
