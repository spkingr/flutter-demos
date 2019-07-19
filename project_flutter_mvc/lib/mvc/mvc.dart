import 'package:flutter/material.dart';

class _MVCState extends State<MCView>{
  _MVCState(this.view);

  final MCView view;

  void reInitState() => this.initState();
  void reDeactivate() => this.deactivate();
  void reDispose() => this.dispose();
  void reState(VoidCallback fn) => this.setState(fn);

  @override
  Widget build(BuildContext context) => this.view.build(context);

}

class MVController{
  _MVCState state;

  get widget => this.state?.widget;
  get context => this.state?.context;
  get mounted => this.state?.mounted;

  void initState() => this.state?.reInitState();
  void deactivate() => this.state?.reDeactivate();
  void dispose() => this.state?.reDispose();

  void setState(VoidCallback fn) => this.state?.reState(fn);
  void refresh() => this.state?.reState((){});
}

abstract class MCView<T extends MVController> extends StatefulWidget{
  const MCView({this.viewController, Key key}):super(key: key);

  final T viewController;

  T get controller => this.viewController;
  MCView<T> get widget => this;
  BuildContext get context => this.viewController.state.context ?? this.createState().context;
  bool get mounted => this.viewController.state.mounted ?? this.createState().mounted;

  @override
  State<StatefulWidget> createState(){
    final state = _MVCState(this);
    this.viewController?.state = state;
    return state;
  }

  void setState(VoidCallback fn) => this.viewController.setState(fn);

  Widget build(BuildContext context);
}