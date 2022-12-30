import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test('should be a subclass of number trivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from JSON', () {
    test('should return a valid model when JSON number is integer', (() async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // expect
      expect(result, tNumberTriviaModel);
    }));

    test('should return a valid model when JSON number is regarded as double',
        (() async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);
    }));
  });

  group("to Json", (() {
    test('should return a jsonmap containing proper data', (() async {
      // act
      final result = tNumberTriviaModel.toJson();

      // assert
      final expectedMap = {"text": "Test Text", "number": 1};
      expect(result, expectedMap);
    }));
  }));
}
