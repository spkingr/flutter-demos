import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    home: BackdropHome(),
  );
}

class Category{
  const Category({this.title, this.images});
  final String title;
  final List<String> images;
}

class BackdropHome extends StatefulWidget{
  final headerHeight = 50.0;
  final data = <Category>[
    const Category(title: "暖手宝", images: <String>["images/sumei_1_1.jpg", "images/sumei_1_2.jpg", "images/sumei_1_3.jpg", "images/sumei_1_4.jpg", "images/sumei_1_5.jpg", "images/sumei_1_6.jpg"]),
    const Category(title: "电风扇 & 灭蚊灯", images: <String>["images/sumei_2_1.jpg", "images/sumei_2_2.jpg", "images/sumei_2_3.jpg"]),
    const Category(title: "热敷包", images: <String>["images/sumei_3_1.jpg", "images/sumei_3_2.jpg"]),
    const Category(title: "暖宝宝", images: <String>["images/sumei_4_1.jpg", "images/sumei_4_2.jpg", "images/sumei_4_3.jpg", "images/sumei_4_4.jpg", "images/sumei_4_5.jpg"]),
  ];

  @override
  _BackdropHomeState createState() => _BackdropHomeState();
}

class _BackdropHomeState extends State<BackdropHome> with TickerProviderStateMixin{

  AnimationController _controller;
  String _currentTitle;
  int _currentIndex;

  bool get _isPanelVisible{
    var status = this._controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  @override
  void initState() {
    this._currentIndex = 0;
    this._currentTitle = this.widget.data[this._currentIndex].title;
    this._controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this, value: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0.0,
      title: this._buildTitle(),
      actions: <Widget>[
        IconButton(
          onPressed: () => this._controller.fling(velocity: this._isPanelVisible ? -1.0 : 1.0),
          icon: AnimatedIcon(progress: this._controller.view, icon: AnimatedIcons.close_menu, ),
        ),
      ],
    ),
    body: LayoutBuilder(builder: this._buildStack,),
  );

  Widget _buildTitle() => Stack(
    children: <Widget>[
      FadeTransition(
        opacity: CurvedAnimation(curve: const Interval(0.5, 1.0), parent: ReverseAnimation(this._controller.view)),
        child: const Text("Select a category"),
      ),
      FadeTransition(
        opacity: CurvedAnimation(curve: const Interval(0.5, 1.0), parent: this._controller.view),
        child: Text(this._currentTitle),
      ),
    ],
  );

  Widget _buildStack(BuildContext context, BoxConstraints constrains){
    var headerHeight = this.widget.headerHeight;
    var selectedData = this.widget.data[this._currentIndex];
    return Material(
      color: Theme.of(this.context).primaryColor,
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: this.widget.data.map((Category data) => this._buildCategory(data)).toList(),
            ),
          ),
          PositionedTransition(
            rect: this._getPageAnimation(this.widget.headerHeight, constrains),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(this.widget.headerHeight), topRight: Radius.circular(this.widget.headerHeight))  ,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () => this._controller.fling(velocity: this._isPanelVisible ? -1.0 : 1.0),
                      child: Container(height: headerHeight, child: Center(child: Text(selectedData.title, style: Theme.of(context).textTheme.title,)),)
                  ),
                  Divider(color: Colors.black26,),
                  Expanded(child: ListView(children: selectedData.images.map((image) => this._buildImageList(image)).toList(),)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageList(String image) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0 ,
        shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
        child: Image.asset(image, fit: BoxFit.contain, /*package: "images",*/),
      )
  );

  Widget _buildCategory(Category data) => GestureDetector(
      onTap: () => this._onCategoryTap(data),
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: this.widget.data.indexOf(data) == this._currentIndex ? BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(8.0)) : null,
          child: Center(child: Text(data.title, style: TextStyle(color: Colors.white, fontSize: 24.0,),),)
      )
  );

  void _onCategoryTap(Category data){
    var index = this.widget.data.indexOf(data);
    if(index != this._currentIndex){
      this.setState(() {
        this._currentIndex = index;
        this._currentTitle = data.title;
        });
      }
      this._controller.fling(velocity: this._isPanelVisible ? -1.0 : 1.0);
  }

  Animation<RelativeRect> _getPageAnimation(double headerHeight, BoxConstraints constrains){
    final stackHeight = constrains.biggest.height;
    final top = stackHeight - headerHeight;
    final bottom = - headerHeight;
      return RelativeRectTween(begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom), end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(CurvedAnimation(parent: this._controller, curve: Curves.linear));
  }

}
