import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/number_trivia/data/data_sorces/number_trivia_remote_data_source.dart';
import 'package:number_trivia/number_trivia/data/models/number_trivia_model.dart';

import '../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<http.Client>(),
])
void main() {
  http.Client client = MockClient();
  const number = 1;
  NumberTriviaRemoteDataSource dataSource = NumberTriviaRemoteDataSourceImpl(client: client);

  void setUpMockHttpClientSuccess200(Uri uri) {
    when(client.get(uri, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404(Uri uri) {
    when(client.get(uri, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('get concrete number trivia', () {
    Uri createConcreteUri() {
      return Uri(scheme: 'http', host: 'numbersapi.com', path: '$number');
    }

    final numberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('should  preform a GET request on a URL with number being the endpoint and with application/json header', () async {
      // arrange
      setUpMockHttpClientSuccess200(createConcreteUri());
      // act
      dataSource.getConcreteNumberTrivia(number);
      // assert
      verify(client.get(
        Uri(scheme: 'http', host: 'numbersapi.com', path: '$number'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      // arrange
      setUpMockHttpClientSuccess200(createConcreteUri());
      // act
      final actual = await dataSource.getConcreteNumberTrivia(number);
      // assert
      expect(actual, equals(numberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      setUpMockHttpClientFailure404(createConcreteUri());
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(number), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('get random number trivia', () {
    Uri createRandomUri() {
      return Uri(scheme: 'http', host: 'numbersapi.com', path: 'random');
    }

    final numberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('should preform a GET request on a URL with random being the endpoint and with application/json header', () async {
      // arrange
      setUpMockHttpClientSuccess200(createRandomUri());
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(client.get(
        Uri(scheme: 'http', host: 'numbersapi.com', path: 'random'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      // arrange
      setUpMockHttpClientSuccess200(createRandomUri());
      // act
      final actual = await dataSource.getRandomNumberTrivia();
      // assert
      expect(actual, equals(numberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      setUpMockHttpClientFailure404(createRandomUri());
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
