import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/number_trivia/domain/entities/number_trivia.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  const numberTriviaModel = NumberTriviaModel(
    number: 1,
    text: 'Test text',
  );

  test('should be a subclass of NumberTrivia entity', () async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('from json', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

        // act
        final actual = NumberTriviaModel.fromJson(jsonMap);

        // assert
        expect(actual, numberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));

        // act
        final actual = NumberTriviaModel.fromJson(jsonMap);

        // assert
        expect(actual, numberTriviaModel);
      },
    );
  });

  group('to json', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // arrange
        // act
        final actual = numberTriviaModel.toJson();

        // assert
        final expected  = {
          'text': 'Test text',
          'number': 1,
        };

        expect(actual, expected);
      },
    );
  });
}
