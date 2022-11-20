import 'package:dartz/dartz.dart';
import 'package:number_trivia/number_trivia/domain/entities/number_trivia.dart';

import '../../../core/errors/failures.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}