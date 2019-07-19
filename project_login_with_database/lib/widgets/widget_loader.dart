import 'package:flutter/material.dart';

class SimpleLoader extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Center(
    child: Card(
      color: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    ),
  );
}