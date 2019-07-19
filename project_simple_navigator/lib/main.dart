import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class Contact{
  Contact(this.name, {this.sex = true, this.age = 18});
  String name;
  bool sex;
  int age;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new MaterialApp(
    title: "?",
    theme: new ThemeData.light(),
    home: new ContactListWidget(),
  );
}

class ContactListWidget extends StatefulWidget{
  @override
  State<ContactListWidget> createState() => new _ContactListWidget();
}

class _ContactListWidget extends State<ContactListWidget>{
  final _contacts = <Contact>[
    new Contact("David Copperfield", sex: false, age: 62),
    new Contact("刘谦", sex: false, age: 40),
    new Contact("David Blane", sex: false, age: 50),
    new Contact("Dynamo", sex: false, age: 30),
    new Contact("Cyril", sex: false, age: 45),
    new Contact("Shiro lshida", sex: false, age: 33),
    new Contact("小林浩平", sex: false, age: 30),
    new Contact("Shin Lim", sex: false, age: 30),
    new Contact("Lennart Green", sex: false, age: 70),
    new Contact("Michael Ammar", sex: false, age: 70),
    new Contact("Daryl", sex: false, age: 62),
  ];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => new Scaffold(
    key: this._scaffoldKey,
    appBar: new AppBar(
      title: const Text("Contact List"),
      leading: const Icon(Icons.contacts),
      actions: <Widget>[new IconButton(icon: const Icon(Icons.add), onPressed: () => this.addContact(this.context))],
    ),
    floatingActionButton: new FloatingActionButton(onPressed: () => this.addContact(this.context), child: const Icon(Icons.add),),
    body: new ListView(
      children: this._contacts.map((contact) => new ListTile(
        title: new Text(contact.name, style: Theme.of(this.context).textTheme.title,),
        subtitle: new Text(contact.sex ? "Female" : "Male"),
        trailing: new Text(contact.age.toString()),
        onTap: () => this.viewContact(contact),
        onLongPress: () => this.editContact(this.context, contact),
      )).toList(),
    ),
  );

  void addContact(BuildContext context){
    var dialog = new ContactDialog();
    showDialog(barrierDismissible: false, context: context, child: dialog).then<void>((contact){
      if(contact != null){
        setState(() => this._contacts.add(contact));
        this._scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("New Contact Added!"), action: new SnackBarAction(label: "Done", onPressed: () => this._scaffoldKey.currentState.hideCurrentSnackBar()),));
      }
    });
  }

  void viewContact(Contact contact){
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ContactWidget(contact)));
  }

  void editContact(BuildContext context, Contact contact){
    var dialog = new SimpleDialog(
      title: new Text("Delete Contact: ${contact.name}?"),
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new SimpleDialogOption(child: new Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: new Text("Delete", style: new TextStyle(color: Colors.red),)), onPressed: () => Navigator.pop(context, true),),
            new SimpleDialogOption(child: new Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: new Text("Cancel", style: new TextStyle(color: Colors.grey),)), onPressed: () => Navigator.pop(context, false),),
          ],
        ),
      ],
    );
    showDialog(context: context, child: dialog).then<void>((isDelete){
      if(isDelete == true){
        setState(() => this._contacts.remove(contact));
      }
    });
  }
}

class ContactDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _ContactDialog();
}

class _ContactDialog extends State<ContactDialog>{
  var _textName = new TextEditingController();
  var _textAge = new TextEditingController();
  var _isFemale = true;

  Contact getContact(){
    if(_textName.text.isEmpty){
      return null;
    }

    int age;
    try{
      age = int.parse(_textAge.text);
    } catch(e){
      print(e);
    } finally{
      age = 0;
    }
    return new Contact(_textName.text, sex: _isFemale, age: age);
  }

  @override
  Widget build(BuildContext context) => new SimpleDialog(
    title: const Text("Add New Contact"),
    children: <Widget>[
      new Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: new TextField(controller: _textName, decoration: new InputDecoration(hintText: "Type new contact..."),),
      ),
      new Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("Female"),
            new Checkbox(value: _isFemale, onChanged: (bool value) => setState(() => _isFemale = value),),
            new Flexible(child: new TextField(controller: _textAge, decoration: new InputDecoration(hintText: "age"),))
          ],
        ),
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new SimpleDialogOption(child: new Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: new Icon(Icons.done, color: Colors.green,)), onPressed: () => Navigator.pop(context, this.getContact()),),
          new SimpleDialogOption(child: new Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: new Icon(Icons.cancel, color: Colors.red,)), onPressed: () => Navigator.pop(context, null),),
        ],
      ),
    ],
  );
}

//The contact widget for new route
class ContactWidget extends StatelessWidget{
  ContactWidget(this.contact);
  final Contact contact;
  @override
  Widget build(BuildContext context) => new MaterialApp(
    title: "?",
    theme: new ThemeData.light(),
    home: new Scaffold(
      appBar: new AppBar(title: new Text(this.contact.name), leading: new FlatButton(onPressed: () => Navigator.of(context).pop(), child: const Icon(Icons.arrow_back, color: Colors.white,)),),
      body: new Center(child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: new Column(
          children: <Widget>[
            new Container(margin: const EdgeInsets.only(top: 16.0),child: new Icon(Icons.people, color: Colors.green, size: 64.0,),),
            new Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[new Text("Name:", style: Theme.of(context).textTheme.title,), new Container(margin: const EdgeInsets.only(left: 8.0) ,child: new Text(this.contact.name, style: Theme.of(context).textTheme.display1,))],),
            new Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[new Text("Sex:", style: Theme.of(context).textTheme.title,), new Container(margin: const EdgeInsets.only(left: 8.0) ,child: new Text(this.contact.sex ? "Female" : "Male", style: Theme.of(context).textTheme.display1,))],),
            new Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[new Text("Age:", style: Theme.of(context).textTheme.title,), new Container(margin: const EdgeInsets.only(left: 8.0) ,child: new Text(this.contact.age.toString(), style: Theme.of(context).textTheme.display1,))],),
            new Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[new Text("Information:", style: Theme.of(context).textTheme.title,), new Container(margin: const EdgeInsets.only(left: 8.0) ,child: new Text("......", style: Theme.of(context).textTheme.display1,))],),
            new Container(margin: const EdgeInsets.only(top: 16.0), padding: const EdgeInsets.symmetric(horizontal: 0.0), child: new RaisedButton(color: Colors.green, onPressed: () => Navigator.of(context).pop(), child: new Row(mainAxisAlignment: MainAxisAlignment.center ,children: <Widget>[const Icon(Icons.arrow_back, color: Colors.white,),new Text("Return", style: new TextStyle(color: Colors.white, fontSize: 16.0),)],),)),
          ],
        ),
      ),),
    ),
  );
}