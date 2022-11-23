import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/number_trivia/data/data_sorces/number_trivia_local_data_source.dart';
import 'package:number_trivia/number_trivia/data/data_sorces/number_trivia_remote_data_source.dart';
import 'package:number_trivia/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    if (await networkInfo.isConnected) {
      try {
        final numberTrivia = await remoteDataSource.getConcreteNumberTrivia(number);
        localDataSource.cacheNumberTrivia(numberTrivia);
        return Right(numberTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastNumberTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final numberTrivia = await remoteDataSource.getRandomNumberTrivia();
        localDataSource.cacheNumberTrivia(numberTrivia);
        return Right(numberTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastNumberTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
