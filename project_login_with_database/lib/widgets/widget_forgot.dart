import 'package:flutter/material.dart';
import '../database/data_class.dart';
import '../database/database_helper.dart';
import 'widget_loader.dart';

class ForgotWidget extends StatefulWidget {
  ForgotWidget({this.onReturn});

  final VoidCallback onReturn;

  @override
  _ForgotWidgetState createState() => _ForgotWidgetState();
}

class _ForgotWidgetState extends State<ForgotWidget> {

  List<User> _data;

  @override
  void initState() {
    super.initState();
    this._initDatabase();
  }

  void _initDatabase() async {
    final database = DatabaseHelper();
    final provider = await database.userProvider;
    final users = await provider.selectAll();
    //provider.close();
    if(this.mounted){
      this.setState(() => this._data = users);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Forgot Page"), leading: IconButton(onPressed: this._onCancel, icon: Icon(Icons.close, color: Colors.green.shade200,),),),
    body: SafeArea(
      top: false,
      bottom: false,
      child: this._data == null ? SimpleLoader() : (this._data.isEmpty ? this._buildEmptyWidget() : this._buildListWidget()),
    ),
  );

  _buildEmptyWidget() => Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text("No users registered now, please register and login!", style: Theme.of(this.context).textTheme.apply(displayColor: Colors.red).title,),
    ),
  );

  _buildListWidget() => ListView(
    padding: const EdgeInsets.all(4.0),
    children: this._data.map((User user) => ListTile(
      title: Text(user.email),
      subtitle: Text(user.userName),
      trailing: Text(user.password),
    )).toList(),
  );

  _onCancel() => this.widget.onReturn();
}
