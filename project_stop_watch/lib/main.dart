import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.dark().copyWith(accentColor: Colors.green),
    home: MyAppHome(),
  );
}

class MyAppHome extends StatefulWidget{
  @override
  State<MyAppHome> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome>{
  _MyAppHomeState({this.frameRate = 30});

  final int frameRate;
  Timer _stateTimer;

  String _textTime = "00:00.00";
  final _stopwatch = Stopwatch();
  int _currentMillisecondsD10 = 0; //divide 10
  bool _isPaused = false;
  List<Record> _records = <Record>[];
  int _lastRecordMilliseconds = 0;
  Record _minRecord;
  Record _maxRecord;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Stop Watch", style: TextStyle(color: Colors.white),), leading: Icon(Icons.watch_later, color: Colors.white,),),
    body: this._buildMainWidget(),
  );

  _buildMainWidget() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(this._textTime, style: TextStyle(fontSize: 48.0, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
              width: 86.0,
              height: 86.0,
              child: FloatingActionButton(
                onPressed: (this._stopwatch.isRunning || this._isPaused) ? this._resetAndRecord : null, elevation: 0.0,
                child: Text(this._isPaused ? "Reset" : "Record", style: TextStyle(fontSize: 20.0, color: (this._stopwatch.isRunning || this._isPaused) ? Colors.white : Colors.blueGrey,),),
              )
          ),
          SizedBox(
              width: 86.0,
              height: 86.0,
              child: FloatingActionButton(
                onPressed: this._startStopWatch, elevation: 0.0,
                child: Text(this._stopwatch.isRunning ? "Stop" : "Start", style: TextStyle(fontSize: 20.0, color: this._stopwatch.isRunning ? Colors.red.shade300 : Colors.white,),),
              )
          ),
        ],
      ),
      Container(margin: const EdgeInsets.only(top: 20.0),child: Divider(color: Colors.white,)),
      Expanded(child: ListView(children: this._records.map((Record record) => this._buildListCell(record)).toList(),)),
    ],
  );

  Widget _buildListCell(Record record) => Container(
    margin: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(record.name, style: TextStyle(fontSize: 18.0, color: this._getRankColor(record.rank)),),
        Text(record.text, style: TextStyle(fontSize: 24.0, color: this._getRankColor(record.rank)),),
      ],
    ),
  );

  Color _getRankColor(Rank rank){
    return rank == Rank.FIRST ? Colors.lightGreen : (rank == Rank.LAST ? Colors.orange : Colors.white);
  }

  _timerRefreshCallback(Timer timer){
    var elapsed = this._stopwatch.elapsedMilliseconds ~/ 10;
    if(this._currentMillisecondsD10 != elapsed){
      _currentMillisecondsD10 = elapsed;
      setState(() {
        this._records[0] = Record("Record ${this._records.length}", this._stopwatch.elapsedMilliseconds - this._lastRecordMilliseconds);
        this._textTime = formatTimeText(elapsed, true);
      });
    }
  }

  _startStopWatch(){
    if(this._stopwatch.isRunning){
      this._stopwatch.stop();
      setState(() {
        this._isPaused = true;
      });
    }else{
      if(this._stateTimer == null){
        this._stateTimer = Timer.periodic(Duration(milliseconds: this.frameRate), this._timerRefreshCallback);
      }
      if(this._records.length == 0){
        var initRecord = Record("Record 1", 0);
        setState(() {
          this._records.add(initRecord);
        });
      }else{
        setState(() {
          this._isPaused = false;
        });
      }
      this._stopwatch.start();
    }
  }

  _resetAndRecord(){
    if(this._stopwatch.isRunning){
      var record = Record("Record ${this._records.length}", this._stopwatch.elapsedMilliseconds - this._lastRecordMilliseconds);
      this._lastRecordMilliseconds = this._stopwatch.elapsedMilliseconds;
      this._setRecordRank(record);
      setState(() {
        this._records.insert(1, record);
      });
    }else if(this._isPaused){
      this._stopwatch.reset();
      this._currentMillisecondsD10 = 0;
      this._lastRecordMilliseconds = 0;
      this._resetRecordRank();
      setState(() {
        this._isPaused = false;
        this._records.clear();
        this._textTime = "00:00.00";
      });
    }
  }

  _resetRecordRank(){
    this._minRecord = null;
    this._maxRecord = null;
  }

  _setRecordRank(Record record){
    if(this._maxRecord != null && this._minRecord != null){
      if(record.time < this._minRecord.time){
        this._minRecord.rank = Rank.OTHER;
        record.rank = Rank.LAST;
        this._minRecord = record;
      }else if(record.time > this._maxRecord.time){
        this._maxRecord.rank = Rank.OTHER;
        record.rank = Rank.FIRST;
        this._maxRecord = record;
      }
    }else if(this._records.length >= 2){
      if(this._records[1].time > record.time){
        this._records[1].rank = Rank.FIRST;
        record.rank = Rank.LAST;
        this._maxRecord = this._records[1];
        this._minRecord = record;
      }else{
        record.rank = Rank.FIRST;
        this._records[1].rank = Rank.LAST;
        this._maxRecord = record;
        this._minRecord = this._records[1];
      }
    }
  }

  @override
  void dispose() {
    this._stateTimer?.cancel();
    this._stateTimer = null;
    super.dispose();
  }
}

enum Rank{
  FIRST, LAST, OTHER
}

class Record{
  final String name;
  final int time;
  final String text;
  Rank rank = Rank.OTHER;

  Record(this.name, this.time) : text = formatTimeText(time);
}

//Util method
String formatTimeText(int milliseconds, [bool divided10 = false]){
  var ms = (milliseconds % (divided10 ? 100 : 1000) ~/ (divided10 ? 1 : 10)).toString().padLeft(2, "0");
  var s = milliseconds ~/ (divided10 ? 100 : 1000);
  var m = s ~/ 60 % 60;
  s = s % 60;
  return "${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}.$ms";
}