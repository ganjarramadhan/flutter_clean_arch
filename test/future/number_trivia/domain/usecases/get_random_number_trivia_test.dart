import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/usecases/usecase.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia useCase;
  late MockNumberTriviaRepository repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(repository);
  });

  const NumberTrivia numberTrivia = NumberTrivia(text: "Test", number: 1);

  test("should get trivia from repository", () async {
    // arrange
    when(() => repository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(numberTrivia));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, const Right(numberTrivia));
    verify(() => repository.getRandomNumberTrivia());
    verifyNoMoreInteractions(repository);
  });
}
