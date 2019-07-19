import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert' show JSON;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new MaterialApp(
    title: "?",
    theme: new ThemeData.light(),
    home: new GithubList(),
  );
}

class GithubList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _GithubList();
}

class _GithubList extends State<GithubList> {
  ScrollController _controller = new ScrollController();
  List<GithubUser> _data;
  String _info = "Loading...";
  IconData _icon = Icons.hourglass_empty;
  var _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    this._isRefreshing = true;
    this._loadData();
  }

  void _loadData() async {
    var urlString = "https://api.github.com/orgs/flutter/members";
    List<GithubUser> list;
    try {
      var url = Uri.parse(urlString);
      var response = await Http.get(url);
      if(response.statusCode == 200) {
        List<Map> users = await JSON.decode(response.body);
        list = this._convertUsers(users);
      }else{
        this._info = "Error in response! Try it later.";
        this._icon = Icons.warning;
      }
    }catch(error){
      this._info = "Error on network! Make sure your network is available.";
        this._icon = Icons.error;
    }

    setState((){
      this._isRefreshing = false;
      this._data = list;
    });
  }

  void _refresh() {
    if(this._isRefreshing) {
      return;
    }

    setState((){
      this._info = "Loading...";
      this._data = null;
    });

    this._isRefreshing = true;
    this._loadData();
  }

  List<GithubUser> _convertUsers(List<Map> users) {
    var list = <GithubUser>[];
    for(var userMap in users){
      var user = new GithubUser()
        ..id = userMap["id"]
        ..login = userMap["login"]
        ..avatarUrl = userMap["avatar_url"]
        ..htmlUrl = userMap["html_url"]
        ..type = userMap["type"]
        ..isAdmin = userMap["site_admin"];
      list.add(user);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: const Text("Github Flutter") , leading: new Icon(Icons.device_hub, color: Colors.white,),),
    body: this._data == null ? this._getEmptyView() : this._getListView(),
    floatingActionButton: new FloatingActionButton(onPressed: (){ this._refresh(); }, child: const Icon(Icons.refresh, color: Colors.white,),),
  );

  Widget _getEmptyView() => new Card(
    color: Colors.limeAccent.shade100,
    child: new Center(child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[new Icon(this._icon, size: 64.0, color: Colors.redAccent.shade100,), new Text(this._info,),],
    ), ),
  );

  ListView _getListView() => new ListView.builder(
    itemCount: this._data.length * 2,
    controller: this._controller,
    itemBuilder: (BuildContext context, int index) {
      if(index.isOdd) {
        return new Divider();
      }
      var i = index ~/ 2;
      return new ListTile(
        leading: new CircleAvatar(backgroundColor: Colors.grey.shade400, backgroundImage: new NetworkImage(this._data[i].avatarUrl),),
        title: new Text(this._data[i].login),
        trailing: this._data[i].isAdmin ? new Icon(Icons.people, color: Colors.greenAccent.shade200,) : null,
      );
    },
  );
}

class GithubUser {

  String login;
  int id;
  String avatarUrl;
  String htmlUrl;
  String type;
  bool isAdmin;

  /*
  "login": "cbracken",
    "id": 351029,
    "avatar_url": "https://avatars3.githubusercontent.com/u/351029?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/cbracken",
    "html_url": "https://github.com/cbracken",
    "followers_url": "https://api.github.com/users/cbracken/followers",
    "following_url": "https://api.github.com/users/cbracken/following{/other_user}",
    "gists_url": "https://api.github.com/users/cbracken/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/cbracken/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/cbracken/subscriptions",
    "organizations_url": "https://api.github.com/users/cbracken/orgs",
    "repos_url": "https://api.github.com/users/cbracken/repos",
    "events_url": "https://api.github.com/users/cbracken/events{/privacy}",
    "received_events_url": "https://api.github.com/users/cbracken/received_events",
    "type": "User",
    "site_admin": false
   */
}