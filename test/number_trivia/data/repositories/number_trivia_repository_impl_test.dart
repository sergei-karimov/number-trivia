import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/number_trivia/data/data_sorces/number_trivia_local_data_source.dart';
import 'package:number_trivia/number_trivia/data/data_sorces/number_trivia_remote_data_source.dart';
import 'package:number_trivia/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  NumberTriviaRemoteDataSource remoteDataSource = MockNumberTriviaRemoteDataSource();
  NumberTriviaLocalDataSource localDataSource = MockNumberTriviaLocalDataSource();
  NetworkInfo networkInfo = MockNetworkInfo();
  NumberTriviaRepositoryImpl repository = NumberTriviaRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );

  group('get concrete number trivia', () {
    const number = 1;
    const text = 'Test text';
    const numberTriviaModel = NumberTriviaModel(number: number, text: text);
    const NumberTrivia numberTrivia = numberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(networkInfo.isConnected).thenAnswer((_) async => true);

        // act
        repository.getConcreteNumberTrivia(number);

        // assert
        verify(networkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(remoteDataSource.getConcreteNumberTrivia(number)).thenAnswer((_) async => numberTriviaModel);

          // act
          final actual = await repository.getConcreteNumberTrivia(number);

          // assert
          verify(remoteDataSource.getConcreteNumberTrivia(number));
          expect(actual, equals(const Right(numberTrivia)));
        },
      );
    });
  });
}
