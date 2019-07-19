import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'dart:async';

void main(){
  group('test the app performance in scroll list', (){
    FlutterDriver driver;
    setUp(() async {
      print("Group test setup:");
      driver = await FlutterDriver.connect();
    });
    tearDownAll(()async{
      print("Group test tear down all.");
      await driver?.close();
    });
    test('mesure', () async {
      print("Group test begin:");
      Timeline timeline = await driver.traceAction(() async{
        final finder = find.byValueKey("my_list_key");
        for(int i = 0; i < 5; i ++){
          await driver.scroll(finder, 0.0, -300.0, const Duration(milliseconds: 300));
          await new Future.delayed(const Duration(milliseconds: 500));
        }
        for(int i = 0; i < 5; i ++){
          await driver.scroll(finder, 0.0, 300.0, const Duration(milliseconds: 300));
          await new Future.delayed(const Duration(milliseconds: 500));
        }
      });

      final summary = new TimelineSummary.summarize(timeline);
      summary.writeSummaryToFile("scroll_performance", destinationDirectory: "test_data", pretty: true);
      summary.writeTimelineToFile("scroll_performance", destinationDirectory: "test_data", pretty: true);
      print("Group test done!");
    });
  });
}