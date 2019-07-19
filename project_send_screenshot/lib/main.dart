import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as UI;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/scheduler.dart' show timeDilation;

void main() => runApp(new MyApp());

final methodChannel = const MethodChannel("me.liuqingwen.screenshot");
final methodName = "onFlutterTakeSceenshot";

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: MyHomePage(),
    theme: ThemeData.light(),
  );
}

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  final _globalKey = GlobalKey();
  var _isWorking = false;

  var _showText = true;
  var _sigma = 0.0;
  var _opacity = 1.0;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    key: this._globalKey,
    child: Scaffold(
      appBar: AppBar(title: const Text("Screenshot To Mail"),),
      body: Center(child: this._isWorking ? CircularProgressIndicator() : this._buildBackdropWithOptions(),),
      floatingActionButton: FloatingActionButton(onPressed: this._onActionShot, child: Icon(Icons.camera, color: Colors.white,),),
    ),
  );

  Widget _buildBackdropFilterWidget() => BackdropFilter(
    filter: UI.ImageFilter.blur(sigmaX: this._sigma, sigmaY: this._sigma),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.25,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            image: DecorationImage(image: AssetImage("images/mountains_day.png"), fit: BoxFit.cover),
          ),
          child: Center(child: this._showText ? Text("Filter Widget") : Container(width: 128.0, height: 64.0, color: Colors.blue.shade400.withOpacity(this._opacity),),),
        ),
      ),
    ),
  );

  /*
  new AnimatedCrossFade(
   duration: const Duration(seconds: 3),
   firstChild: const FlutterLogo(style: FlutterLogoStyle.horizontal, size: 100.0),
   secondChild: const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0),
   crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
   )
   */

  Widget _buildBackdropWithOptions() => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        this._buildBackdropFilterWidget(),
        const Text("Sigma"),
        Slider(value: this._sigma, min: 0.0, max: 100.0, onChanged: (value) => this.setState(() => this._sigma = value),),
        const Text("Opacity"),
        Slider(value: this._opacity * 100, min: 0.0, max: 100.0, onChanged: (value) => this.setState(() => this._opacity = value / 100),),
        Checkbox(value: this._showText, onChanged: (value) => this.setState(() => this._showText = value),)
      ],
    ),
  );

  void _onActionShot() async{
    if(this._isWorking){
      return;
    }

    this.setState(() => this._isWorking = true);

    try{
      final renderObject = this._globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;

      final image = await renderObject.toImage();
      final imageData = await image.toByteData(format: UI.ImageByteFormat.png);
      final byteData = imageData.buffer.asUint8List();

      final directory = (await getExternalStorageDirectory()).path;
      final file = File("$directory/screenshot.png");
      await file.writeAsBytes(byteData);

      await methodChannel.invokeMethod(methodName, {"filePath" : file.path});
    } on PlatformException catch(e){
      print(e.toString());
    } on MissingPluginException catch(e){
      print(e.toString());
    } on Exception catch(e) {
      print(e.toString());
    } catch (e) {
      print(e);
    }

    this.setState(() => this._isWorking = false);
  }
}


/*
_onWillPop(){
  FocusScope.of(context).requestFocus(FocusNode());
  return Future.value(true);
}
var w = WillPopScope(child: null, onWillPop: _onWillPop);
var w = TextField(focusNode: FocusNode(),);
*/
