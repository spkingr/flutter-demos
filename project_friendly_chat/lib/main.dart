import 'package:flutter/material.dart';
import 'dart:math' show Random;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => new MaterialApp(
    title: '?',
    theme: new ThemeData(primarySwatch: Colors.pink,),
    home: new ChatWidget(),
  );
}

class ChatWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ChatWidget();
}

class _ChatWidget extends State<ChatWidget> with TickerProviderStateMixin{

  final _controller = new TextEditingController();
  final _messages = <AnimatedMessage>[];
  var _title = "Chat Room";
  var _hasText = false;

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(title: new Text(this._title),),
    body: new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        this._getContentComponent(),
        new Divider(color: Colors.blue,),
        this._getMessageComponent(),
      ],
    ),
  );

  void _onSendMessage(String text){
    if(text.isEmpty){
      return;
    }

    this._controller.clear();
    var message = new AnimatedMessage(name: "Your Name", content: text, controller: new AnimationController(vsync: this, duration: const Duration(milliseconds: 600)));
    setState((){
      this._hasText = false;
      this._messages.insert(0, message);
    });
    message.controller.forward();

    this._randomReceiveMessage(message.controller);
  }

  void _randomReceiveMessage(AnimationController controller){
    if(this._messages.length % 4 == 0 || this._messages.length % 9 == 0){
      var min = "A".codeUnitAt(0);
      var max = "Z".codeUnitAt(0);
      var name = new Random().nextInt(max - min) + min + 1;
      var randomName = "Name ${new String.fromCharCode(name)}";
      var index = new Random().nextInt(Words.words.length);
      var randomContent = Words.words[index];
      var message = new AnimatedMessage(isForward: false, name: randomName, content: randomContent, controller: new AnimationController(vsync: this, duration: const Duration(milliseconds: 600)));
      controller.addStatusListener((status){
        if(status == AnimationStatus.completed){
          setState(() => this._messages.insert(0, message));
          message.controller.forward();
        }
      });
    }
  }

  void _onTextChanged(String text){
    if((text.isEmpty && this._hasText) || (text.isNotEmpty && !this._hasText)){
      setState(() => this._hasText = text.isNotEmpty);
    }
  }

  Widget _getMessageComponent() => new Container(
    margin: const EdgeInsets.only(bottom: 10.0),
    child: new Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Flexible(
          child:  new Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: new TextField(
              controller: this._controller,
              onChanged: this._onTextChanged,
              onSubmitted: this._onSendMessage,
              decoration: new InputDecoration(hintText: "Type message here"),
            ),
          ),
        ),
        new IconButton(
          icon: new Icon(Icons.send, color: Colors.blueAccent.shade200,),
          onPressed: this._hasText ? ()=>this._onSendMessage(this._controller.text) : null,
        ),
      ],
    ),
  );

  Widget _getContentComponent() => new Flexible(child: new ListView.builder(
    reverse: true,
    itemCount: this._messages.length,
    itemBuilder: (_, index) => this._messageToWidget(this._messages[index]),
  ));

  Widget _messageToWidget(AnimatedMessage message) => new SizeTransition(
    sizeFactor: message.controller,
    axisAlignment: -1.0,
    child: new Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0,),
      child: message.isForward ? new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: new CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.blue.shade300,
              child: new Text(message.name.substring(0, 1).toUpperCase(), style: Theme.of(this.context).textTheme.title,),
            )
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(message.name, style: Theme.of(this.context).textTheme.subhead,),
                new Container(margin: const EdgeInsets.only(top: 4.0), child: new Text(message.content, style: Theme.of(this.context).textTheme.body1,)),
              ],
            ),
          ),
        ],
      ) : new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(message.name, style: Theme.of(this.context).textTheme.subhead,),
                new Container(margin: const EdgeInsets.only(top: 4.0), child: new Text(message.content, style: Theme.of(this.context).textTheme.body1,)),
              ],
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: new CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.green.shade300,
              child: new Text(message.name.substring(message.name.length - 1, message.name.length).toUpperCase(), style: Theme.of(this.context).textTheme.title,),
            )
          ),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    this._messages.forEach((message) => message.controller.dispose());
    super.dispose();
  }
}

class AnimatedMessage {
  AnimatedMessage({this.name, this.content, this.controller, this.isForward = true, });

  final String name;
  final bool isForward;
  final String content;
  final AnimationController controller;
}

class Words {
  static final words = <String>[
    """Flutter is Google’s mobile UI framework for crafting high-quality native interfaces on iOS and Android in record time.""",
    """Flutter works with existing code, is used by developers and organizations around the world, and is free and open source. Learn more at https://flutter.io""",
    """Hello! How are you?""",
    """Flutter is just rocks! How do you think?""",
    """Ennn...""",
    """你好，我实在搞不懂你是在讲些什么话？你能不能讲的在清楚一点？或者用火星语来表达一下？^_^""",
    """We are super excited to announce a fully-featured, animated charting library for Flutter!""",
    """Flutter’s hot reload is so hot right now.""",
    """Running unit tests as part of your everyday Flutter workflow.""",
    """...""",
  ];
}