import 'package:flutter/material.dart';

class MySecondPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Second Page"),),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(child: Padding(padding: const EdgeInsets.all(20.0), child: Icon(Icons.android, color: Colors.blue, size: 200.0,),),),
          Padding(padding: const EdgeInsets.symmetric(vertical: 20.0), child: Text("The second page", textAlign: TextAlign.center, style: Theme.of(context).textTheme.display1,),)
        ],
      ),
    ),
  );
}