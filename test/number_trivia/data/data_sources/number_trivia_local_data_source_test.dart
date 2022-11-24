import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/number_trivia/data/data_sorces/number_trivia_local_data_source.dart';
import 'package:number_trivia/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferences>(),
])
void main() {
  SharedPreferences sharedPreferences = MockSharedPreferences();
  NumberTriviaLocalDataSource dataSource = NumberTriviaLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  group('get last number trivia', () {
    final numberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));

    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async {
      // arrange
      when(sharedPreferences.getString('CACHED_NUMBER_TRIVIA')).thenReturn(fixture('trivia_cached.json'));

      // act
      final actual = await dataSource.getLastNumberTrivia();

      // assert
      verify(sharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(actual, equals(numberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(sharedPreferences.getString('CACHED_NUMBER_TRIVIA')).thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
