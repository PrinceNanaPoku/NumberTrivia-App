import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:newapp/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:newapp/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");
  test(
      "There should be a subclass of number trivia entity",
      () async => {
            //assert
            expect(testNumberTriviaModel, isA<NumberTrivia>())
          });
  group("from JSON", () {
    test(
      "should return a valid model when the JSON number is an integer",
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, testNumberTriviaModel);
      },
    );

    test(
      "should return a valid model when the JSON number is an integer",
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));

        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, testNumberTriviaModel);
      },
    );
    group("to JSON", () {
      test("should return a JSON map containing the proper data", () async {
        //act
        final result = testNumberTriviaModel.toJson();
        //assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      });
    });
  });
}
