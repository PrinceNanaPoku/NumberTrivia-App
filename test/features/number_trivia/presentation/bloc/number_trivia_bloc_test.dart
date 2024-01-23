import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newapp/core/util/input_converter.dart';
import 'package:newapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:newapp/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:newapp/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:newapp/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getGetConcretNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initial State should be Empty', () {
    //assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const testNumberString = '1';
    const testNumberParsed = 1;
    final testNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
        'should call the InputConverter to validate and convert the stirng to an unsigned integer',
        () async {
      //assert
      when(mockInputConverter.stringToUnsignedInteger('1'))
          .thenReturn(const Right(testNumberParsed));
      //act
      bloc.add(GetTriviaForConcreteNumber(testNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger('1'));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
    });

    test('should emit [ERROR] when the input is invalid', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger("1")).thenReturn(
        (Left(
          InvalidInputFailure(),
        )),
      );

      //assert later

      final expected = [
        Empty(),
        Error(message: invalidInputFailureMessage),
      ];

      expectLater(bloc.state, expected);

      //act
      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });
  });
}
