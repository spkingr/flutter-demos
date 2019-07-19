import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.light(),
    home: MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget{
  @override
  createState() => _MyHomePageState();
}

class TabData{
  TabData(this.title, this.icon, this.widget);

  final String title;
  final Icon icon;
  final Widget widget;
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  final _imageHeader = "https://avatars0.githubusercontent.com/u/255900?s=460&v=4";
  final _imageBackground = "http://liuqingwen.me/upload/images/android/Android_background.png";

  final _mainTabsTitles = <TabData>[TabData("Text", Icon(Icons.text_fields), null), TabData("Icon", Icon(Icons.insert_emoticon), null), TabData("Color", Icon(Icons.color_lens), null),];
  TabController _mainTabController;

  final _childTabsTitles = <List<TabData>>[
    <TabData>[TabData("Sub Title A", null, Card(child: Text("A", maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 48.0), ),)), TabData("Sub Title B", null, Card(child: Text("B", maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 48.0), ),)), TabData("Sub Title C", null, Card(child: Text("C", maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 48.0), ),)),],
    <TabData>[TabData("Car", null, Card(child: Icon(Icons.directions_car, size: 128.0,),)), TabData("Moto", null, Card(child: Icon(Icons.motorcycle, size: 128.0,),)), TabData("Bus", null, Card(child: Icon(Icons.directions_bus, size: 128.0,),)), TabData("Plane", null, Card(child: Icon(Icons.local_airport, size: 128.0,),)), TabData("Tram", null, Card(child: Icon(Icons.tram, size: 128.0,),)),],
    <TabData>[TabData("Red", null, Card(color: Colors.red,)), TabData("Blue", null, Card(color: Colors.blue,)), TabData("Green", null, Card(color: Colors.green,)), TabData("Orange", null, Card(color: Colors.orange,)), TabData("Purple", null, Card(color: Colors.purple,)), TabData("Cyan", null, Card(color: Colors.cyan,)),],
  ];
  List<TabController> _childTabControllers;

  var _selectedTabIndex = 0;

  @override
  void initState() {
    this._mainTabController = TabController(vsync: this, length: this._mainTabsTitles.length);
    this._childTabControllers = this._childTabsTitles.map<TabController>((List<TabData> tabs) => TabController(vsync: this, length: tabs.length)).toList();
    this._mainTabController.addListener((){
      this.setState(() => this._selectedTabIndex = this._mainTabController.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    this._mainTabController.dispose();
  }

  @override
  build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Tabs"), bottom: this._buildChildTabs(this._selectedTabIndex),),
    drawer: this._buildDrawer(),
    body: this._buildBody(),
    bottomNavigationBar: this._buildMainTabs(),
    floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.home, color: Colors.white,),),
  );

  _buildBody() => Container(
    child: TabBarView(controller: this._mainTabController, children: this._buildChildTabBarView(this._childTabsTitles),),
  );

  _buildChildTabBarView(List<List<TabData>> tabTitles){
    List<Widget> widgets = List<TabBarView>();
    for(int i = 0; i < tabTitles.length; i ++){
      var tabs = tabTitles[i];
      var controller = this._childTabControllers[i];
      var tabBarView = TabBarView(controller: controller, children: tabs.map((TabData tab)=>Center(child: Container(margin: EdgeInsets.all(50.0), child: AspectRatio(aspectRatio: 1.0, child: tab.widget,),))).toList(),);
      widgets.add(tabBarView);
    }
    return widgets;
  }

  _toHome() => Navigator.pop(this.context);

  _buildMainTabs() => TabBar(
    labelColor: Colors.blue,
    unselectedLabelColor: Colors.grey,
    controller: this._mainTabController,
    tabs: this._mainTabsTitles.map<Tab>( (TabData data) => Tab(text: data.title, icon: data.icon,) ).toList(),
  );

  _buildChildTabs(int index) => TabBar(
    controller: this._childTabControllers[index],
    tabs: this._childTabsTitles[index].map<Tab>( (TabData tab) => Tab(text: tab.title,) ).toList(),
  );

  _buildDrawer() => Drawer(
    elevation: 4.0,
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Qingwen Liu"),
          accountEmail: Text("liuqingwen@163.com"),
          currentAccountPicture: CircleAvatar(radius: 24.0, backgroundImage: NetworkImage(this._imageHeader),),
          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(this._imageBackground),),),
          onDetailsPressed: () => this._toHome ,
        ),
        ListTile(title: Text("Home"), trailing: Icon(Icons.home, color: Colors.blue,), onTap: this._toHome ,),
        ListTile(title: Text("Blog"), trailing: Icon(Icons.web_asset, color: Colors.blue), onTap: this._toHome ,),
        ListTile(title: Text("Settings"), trailing: Icon(Icons.settings, color: Colors.blue), onTap: this._toHome ,),
        Divider(),
        ListTile(title: Text("Quit"), trailing: Icon(Icons.exit_to_app, color: Colors.red,), onTap: this._toHome ,),
      ],
    ),
  );
}