import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main() {
  MockNumberTriviaRepository mockRepository = MockNumberTriviaRepository();
  GetConcreteNumberTrivia usecase = GetConcreteNumberTrivia(mockRepository);

  const number = 1;
  const numberTrivia = NumberTrivia(number: number, text: 'Test text');

  test('should get trivia for number from the repository', () async {
    when(mockRepository.getConcreteNumberTrivia(number)).thenAnswer((_) async => const Right(numberTrivia));

    final actual = await usecase(number: number);

    expect(actual, const Right(numberTrivia));
    verify(mockRepository.getConcreteNumberTrivia(number));
    verifyNoMoreInteractions(mockRepository);
  });
}
