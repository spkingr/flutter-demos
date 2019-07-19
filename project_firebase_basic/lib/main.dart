import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.light(),
    home: MyHomePage(),
  );
}

const String COLLECTION_NAME = "blog-posts";
const String FIELD_TITLE = "title";
const String FIELD_READ = "read";
const String FIELD_CONTENT = "content";

class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Blog Posts"),),
    floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add, color: Colors.white,),),
    body: StreamBuilder(
      stream: Firestore.instance.collection(COLLECTION_NAME).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData ? this._buildContent(snapshot.data.documents) : const Text("Loading..."),
    ),
  );

  Widget _buildContent(List<DocumentSnapshot> documents) => ListView.builder(
    itemCount: documents.length,
    padding: const EdgeInsets.only(top: 10.0),
    itemExtent: 55.0,
    itemBuilder: (BuildContext context, int index) => this._buildItem(context, documents[index]),
  );

  Widget _buildItem(BuildContext context, DocumentSnapshot document) => ListTile(
    key: ValueKey(document.documentID),
    onTap: () => this._readAndUpdate(context, document),
    title: Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(document[FIELD_TITLE]),),
          Text(document[FIELD_READ].toString()),
        ],
      ),
    ),
  );

  void _readAndUpdate(BuildContext context, DocumentSnapshot document) {
    Firestore.instance.runTransaction((transition) async {
      var freshSnap = await transition.get(document.reference);
      await transition.update(freshSnap.reference, {FIELD_READ : freshSnap[FIELD_READ] + 1});
    });

    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PostContentPage()));
  }
}

class PostContentPage extends StatelessWidget{
  PostContentPage({this.title, this.read, this.content});

  final String title;
  final int read;
  final String content;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.light(),
    home: Scaffold(
      appBar: AppBar(title: Text(this.title),),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pop(context), child: Icon(Icons.home, color: Colors.white,),),
      body: Column(
        children: <Widget>[
          Text(this.title),
          Text(this.content),
          Text("Read: ${this.read + 1}"),
        ],
      ),
    ),
  );
}