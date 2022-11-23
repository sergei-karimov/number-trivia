import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
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

    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);

      // act
      repository.getConcreteNumberTrivia(number);

      // assert
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => true));

      test('should return remote data when the call to remote data source is successful', () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(number)).thenAnswer((_) async => numberTriviaModel);

        // act
        final actual = await repository.getConcreteNumberTrivia(number);

        // assert
        verify(remoteDataSource.getConcreteNumberTrivia(number));
        expect(actual, equals(const Right(numberTrivia)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(number)).thenAnswer((_) async => numberTriviaModel);

        // act
        await repository.getConcreteNumberTrivia(number);

        // assert
        verify(localDataSource.cacheNumberTrivia(numberTriviaModel));
        verify(remoteDataSource.getConcreteNumberTrivia(number));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(number)).thenThrow(ServerException());

        // act
        final actual = await repository.getConcreteNumberTrivia(number);

        // assert
        verify(remoteDataSource.getConcreteNumberTrivia(number));
        verifyNever(localDataSource.getLastNumberTrivia());
        expect(actual, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() async => when(networkInfo.isConnected).thenAnswer((_) async => false));

      test('should return last locally cached data when the cached data is present', () async {
        // arrange
        when(localDataSource.getLastNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

        // act
        final actual = await repository.getConcreteNumberTrivia(number);

        // assert
        expect(false, await networkInfo.isConnected);
        verify(localDataSource.getLastNumberTrivia());
        verifyNever(remoteDataSource.getConcreteNumberTrivia(number));
        expect(actual, equals(const Right(numberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        // arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        // act
        final actual = await repository.getConcreteNumberTrivia(number);

        // assert
        verifyNever(remoteDataSource.getConcreteNumberTrivia(number));
        expect(actual, equals(Left(CacheFailure())));
      });
    });
  });

  group('get random number trivia', () {
    const number = 999;
    const text = 'Random text';
    const numberTriviaModel = NumberTriviaModel(number: number, text: text);
    const NumberTrivia numberTrivia = numberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);

      // act
      repository.getRandomNumberTrivia();

      // assert
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => true));

      test('should return remote data when the call to remote data source is successful', () async {
        // arrange
        when(remoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

        // act
        final actual = await repository.getRandomNumberTrivia();

        // assert
        verify(remoteDataSource.getRandomNumberTrivia());
        expect(actual, equals(const Right(numberTrivia)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(remoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

        // act
        await repository.getRandomNumberTrivia();

        // assert
        verify(localDataSource.cacheNumberTrivia(numberTriviaModel));
        verify(remoteDataSource.getRandomNumberTrivia());
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(remoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyNever(localDataSource.cacheNumberTrivia(numberTriviaModel));
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => false));

      test('should return last locally cached data when the cached data is present', () async {
        // arrange
        when(localDataSource.getLastNumberTrivia()).thenAnswer((_) async => numberTriviaModel);

        // act
        final actual = await repository.getRandomNumberTrivia();

        // assert
        verify(localDataSource.getLastNumberTrivia());
        verifyNever(remoteDataSource.getConcreteNumberTrivia(number));
        expect(actual, equals(const Right(numberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        // arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        // act
        final actual = await repository.getRandomNumberTrivia();

        // assert
        verify(localDataSource.getLastNumberTrivia());
        verifyNever(remoteDataSource.getRandomNumberTrivia());
        expect(actual, equals(Left(CacheFailure())));
      });
    });
  });
}
