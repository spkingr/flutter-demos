import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_reactive_flutter/database/data_class.dart';

class MockBook extends Mock implements Book{}

void main(){
  test('Test mockito', (){
    final book = MockBook();
    when(book.toMap()).thenReturn(<String, dynamic>{"id":1, "name":"Book1"});
    book.toMap();
    verify(book.toMap());
  });
}