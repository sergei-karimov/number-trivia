import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> call({
    required int number,
  }) async {
    return await repository.getRandomNumberTrivia();
  }
}