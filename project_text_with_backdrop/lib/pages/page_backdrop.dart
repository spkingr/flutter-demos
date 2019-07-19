import 'package:flutter/material.dart';

class BackdropPage extends StatefulWidget{

  static const PAGE_NAME = "backdrop";

  @override
  _BackdropPageState createState() => _BackdropPageState();
}

class _BackdropPageState extends State<BackdropPage> with TickerProviderStateMixin{

  static const _PANEL_HEADER_HEIGHT = 64.0;

  AnimationController _animationController;

  bool get _isPanelVisible{
    final status = this._animationController.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  @override
  void initState() {
    super.initState();
    this._animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000), value: 1.0);
    //var animation = Tween(begin: 0.0, end: 1.0).animate(this._animationController);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0.0,
      title: Text("First"),
      leading: IconButton(
        onPressed: () => this._animationController.fling(velocity: this._isPanelVisible ? -1.0 : 1.0),
        icon: AnimatedIcon(progress: this._animationController.view, icon: AnimatedIcons.close_menu,),
      ),
    ),
    body: LayoutBuilder(builder: this._buildStack,),
    floatingActionButton: FloatingActionButton(onPressed: () => Navigator.of(this.context).pop(), child: const Icon(Icons.home, color: Colors.white,),),
  );

  Widget _buildStack(BuildContext context, BoxConstraints constrains) => Container(
    color: Theme.of(this.context).primaryColor,
    child: Stack(
      children: <Widget>[
        Center(child: Text("This is the base content here", style: TextStyle(color: Colors.white, fontSize: 18.0),),),
        PositionedTransition(
          rect: this._getPanelAnimation(constrains),
          child: Material(
            elevation: 12.0,
            borderRadius: const BorderRadius.only(topLeft: const Radius.circular(16.0), topRight: const Radius.circular(16.0)),
            child: Column(
              children: <Widget>[
                Container(height: _BackdropPageState._PANEL_HEADER_HEIGHT, child: Center(child: Text("Panel Title", style: Theme.of(this.context).textTheme.display1,),),),
                Expanded(child: Center(child: Card(child: Icon(Icons.home, size: 256.0, color: Colors.lightGreen,)),),),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constrains){
    final height = constrains.biggest.height;
    final top = height - _BackdropPageState._PANEL_HEADER_HEIGHT;
    final bottom = - _BackdropPageState._PANEL_HEADER_HEIGHT;
    return RelativeRectTween(begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom), end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0)).animate(CurvedAnimation(curve: Curves.linear, parent: this._animationController));
  }

  @override
  void dispose() {
    this._animationController.dispose();
    super.dispose();
  }
}