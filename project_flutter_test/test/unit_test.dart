@TestOn("vm")
@Timeout(const Duration(seconds: 5))
@Tags(const ["vm"])

import 'dart:async';
import 'package:async/async.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_flutter_test/main.dart';

int _myAdd(int a, int b) => a + b;
class MockCat extends Mock implements Cat{}

void main(){
  group('Normal unit test', (){
    test('Funection tst', (){
      expect(_myAdd(1, 2), 3);
      expect("abc,123,xxx".split(r","), allOf(hasLength(3), anyElement("xxx")));
    });

    test('Future Stream tests', () async {
      expect(Future.value(20), completion(equals(20)));
      expect(Future.error("eee"), throwsA(equals("eee")));
      expect(Future.error(StateError("bad state")), throwsStateError);

      var stream = Stream.fromIterable(['a', 'b', 'c']);
      stream.listen(expectAsync1((text){
        expect(text, hasLength(1));
      }, count: 3));

      stream = Stream.fromIterable(["abc", "123", "OK"]);
      expect(stream, emitsInOrder(["abc", contains("23"), emitsAnyOf(["OK", "NO"]), emitsDone]));

      stream = Stream.fromIterable(["abc", "123", "OK"]);
      final queue = StreamQueue(stream);
      expect(queue, emitsThrough("abc"));
      final text = await queue.next;
      expect(text, equals("123"));
      expect(queue, emits(equals("OK")));
      expect(queue, emitsDone);
    });
  });

  test('Mockito test', (){
    final cat = MockCat();
    cat.sound();
    verify(cat.sound());

    expect(cat.sound(), isNull);
    when(cat.sound()).thenReturn("cat sound");
    expect(cat.sound(), "cat sound");
    expect(cat.sound(), "cat sound");

    expect(cat.lives, null);
    when(cat.lives).thenReturn(555);
    expect(cat.lives, 555);
    when(cat.lives).thenThrow(RangeError("Error!"));
    expect(() => cat.lives, throwsRangeError);

    final response = ["abc", "123"];
    when(cat.sound()).thenAnswer((_) => response.removeAt(0));
    expect(cat.sound(), "abc");
    expect(cat.sound(), "123");
  });

  test('Mockito test part2', () {
    final cat = MockCat();

    when(cat.eatFood('fish')).thenReturn(true);
    when(cat.walk(['a', 'b'])).thenReturn(24);
    when(cat.eatFood(typed(argThat(startsWith("xyz"))), hungry: typed(any, named: "hungry"))).thenReturn(true);
    when(cat.eatFood(typed(argThat(startsWith('abc'))), hungry: true)).thenReturn(false);

    expect(cat.eatFood('fish'), isTrue);
    expect(cat.walk(['a', 'b']), 24);
    expect(cat.eatFood('xyz 1'), isTrue);
    expect(cat.eatFood('abc 1 2', hungry: true), isFalse);

    verify(cat.eatFood('fish'));
    verify(cat.walk(['a', 'b']));
    verify(cat.eatFood(typed(argThat(contains('xyz'))), hungry: typed(any, named: "hungry")));
    verify(cat.eatFood(typed(argThat(contains('1 2'))), hungry: true));

    cat.sound();
    cat.sound();

    verify(cat.sound()).called(2);
    //verify(cat.sound()).called(greaterThan(1));
    verifyNever(cat.eatFood(typed(any), hungry: typed(any, named: "hungry")));

    cat.eatFood("abc");
    cat.sound();
    cat.eatFood("xyz");
    verifyInOrder([cat.eatFood("abc"), cat.sound(), cat.eatFood("xyz")]);

    cat.eatFood("fish");
    expect(verify(cat.eatFood(typed(captureAny), hungry: typed(any, named: "hungry"))).captured.single, "fish");
    cat.eatFood("a");
    cat.eatFood("b");
    expect(verify(cat.eatFood(typed(captureAny), hungry: typed(any, named: "hungry"))).captured, ["a", "b"]);
    cat.eatFood("a1");
    cat.eatFood("b1");
    expect(verify(cat.eatFood(typed(captureThat(startsWith("a"))), hungry: typed(any, named: "hungry"))).captured, ["a1"]);

    cat.eatFood("fish");
    //await untilCalled(cat.sleep());

    cat.lives = 10;
    verify(cat.lives = 10);

    logInvocations([cat]);

    clearInteractions(cat);
    reset(cat);
    verifyNoMoreInteractions(cat);
  });


  test('Mockito test part3', () {
    final cat = MockCat();
    /*when(cat.eatFood(any, hungry: anyNamed('hungry'))).thenReturn(0);
    when(cat.eatFood(any, hungry: argThat(isNotNull, named: 'hungry'))).thenReturn(0);
    when(cat.eatFood(any, hungry: captureAnyNamed('hungry'))).thenReturn(0);
    when(cat.eatFood(any, hungry: captureArgThat(isNotNull, named: 'hungry'))).thenReturn(0);*/

  });
  test('Mockito test spy', (){
    /*final cat = spy(MockCat(), Cat());
    when(cat.sound()).thenReturn("abc");
    expect(cat.sound(), "abc");

    //Real object
    expect(cat.lives, 9);*/
  }, skip: "Cannot import mirrors library for spy test!", timeout: Timeout.factor(2));
}
