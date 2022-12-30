import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia useCase;
  late MockNumberTriviaRepository repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(repository);
  });

  const int testNumber = 1;
  const NumberTrivia numberTrivia = NumberTrivia(text: "Test", number: 1);

  test("should get trivia for the number from repository", () async {
    // arrange
    when(() => repository.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(numberTrivia));

    // act
    final result = await useCase(const Params(number: testNumber));

    // assert
    expect(result, const Right(numberTrivia));
    verify(() => repository.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(repository);
  });
}
