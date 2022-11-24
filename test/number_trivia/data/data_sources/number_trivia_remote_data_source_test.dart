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

  Uri createUri() {
    return Uri(scheme: 'http', host: 'numbersapi.com', path: '$number');
  }

  void setUpMockHttpClientSuccess200() {
    when(client.get(createUri(), headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(client.get(createUri(), headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('get concrete number trivia', () {
    final numberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('should  preform a GET request on a URL with number being the endpoint and with application/json header', () async {
      // arrange
      setUpMockHttpClientSuccess200();
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
      setUpMockHttpClientSuccess200();
      // act
      final actual = await dataSource.getConcreteNumberTrivia(number);
      // assert
      expect(actual, equals(numberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(number), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('get random number trivia', () {});
}
