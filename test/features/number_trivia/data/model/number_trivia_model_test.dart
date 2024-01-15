import 'package:flutter_test/flutter_test.dart';
import 'package:newapp/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:newapp/features/number_trivia/domain/entities/number_trivia.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");
  test(
      "There should be a subclass of number trivia entity",
      () async => {
            //assert
            expect(testNumberTriviaModel, isA<NumberTrivia>())
          });
}
