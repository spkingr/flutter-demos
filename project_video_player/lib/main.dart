import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main(){
  final store = Store(changeThemeReducer, initialState: ThemeDataModel(ThemeData.dark(), name: "Light Theme",));
  final app = StoreProvider(
    store: store,
    child: StoreConnector(
      converter: (Store<ThemeDataModel> store) => store.state,
      builder: (BuildContext context, ThemeDataModel data) => MyApp(theme: data.data,),
    )
  );
  runApp(app);
}

typedef OnStateChange = Function(TargetPlatform);

class ThemeDataModel{
  final ThemeData data;
  final String name;

  ThemeDataModel(this.data, {this.name});
}

ThemeDataModel changeThemeReducer(ThemeDataModel state, Object action){
  if(action is ThemeDataModel){
    return ThemeDataModel(action.data, name: action.name);
  }
  return state;
}

class MyApp extends StatelessWidget{
  MyApp({this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Redux',
      theme: this.theme,
      home: StoreConnector(
        converter: (Store<ThemeDataModel> store) => store.state,
        builder: (BuildContext context, ThemeDataModel data) => MyAppHome(title: data.name,),
      ),
    );
}

class MyAppHome extends StatelessWidget{
  MyAppHome({this.title, this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(this.title),),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              //child: this._controller.value.initialized ? AspectRatio(aspectRatio: this._controller.value.aspectRatio, child: VideoPlayer(this._controller)) : Container(),
              child: Chewie(
                VideoPlayerController.network('http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4'),
                autoInitialize: false,
                showControls: true,
                aspectRatio: 16 / 9,
                autoPlay: true,
                looping: false,
                placeholder: Container(color: Colors.grey,),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(child: FlatButton(onPressed: (){VideoPlayerController.network('http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4');}, child: Text('Video 1'))),
              Expanded(child: FlatButton(onPressed: (){VideoPlayerController.network('http://liuqingwen.me/test/video/test.flv');}, child: Text('Video 2'))),
            ],
          ),
          Row(
            children: <Widget>[
              StoreConnector<ThemeDataModel, OnStateChange>(
                converter: (Store<ThemeDataModel> store) => (TargetPlatform platform) => store.dispatch(ThemeDataModel(ThemeData.light(), name: "Light Theme",)),
                builder: (BuildContext context, OnStateChange callback) => Expanded(child: FlatButton(onPressed: () => callback(TargetPlatform.android), child: Text('Android'))),
              ),
              StoreConnector<ThemeDataModel, OnStateChange>(
                converter: (Store<ThemeDataModel> store) => (TargetPlatform platform) => store.dispatch(ThemeDataModel(ThemeData.dark(), name: "Dark Theme",)),
                builder: (BuildContext context, OnStateChange callback) => Expanded(child: FlatButton(onPressed: () => callback(TargetPlatform.iOS), child: Text('iOS'))),
              ),
            ],
          ),
        ],
      ),
  );
}
