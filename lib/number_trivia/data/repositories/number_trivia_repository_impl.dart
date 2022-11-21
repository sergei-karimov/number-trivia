import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
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
    networkInfo.isConnected;

    return Right(await remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
