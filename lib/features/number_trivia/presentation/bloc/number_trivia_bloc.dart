// ignore_for_file: type_literal_in_constant_pattern

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:newapp/core/error/failure.dart';
import 'package:newapp/core/util/input_converter.dart';
import 'package:newapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:newapp/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:newapp/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:newapp/features/number_trivia/domain/usecases/usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = "Server Failure";
const String cacheFailureMessage = "Cache Failure";
const String invalidInputFailureMessage =
    "Invalid Input - Input must be a positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getGetConcretNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getGetConcretNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {
      if (event is GetTriviaForConcreteNumber) {
        inputConverter.stringToUnsignedInteger(event.numberString);

        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither.fold((failure) async* {
          yield Error(message: invalidInputFailureMessage);
        }, (integer) async* {
          yield Loading();
          final failureOrTrivia =
              await getGetConcretNumberTrivia(Params(number: integer));
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        });
      } else if (event is GetTriviaForRandomNumber) {
        () async* {
          yield Loading();
          final failureOrTrivia = await getRandomNumberTrivia(NoParam());
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        };
      }
    });
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
        (failure) => Error(
              message: _mapFailureToMessage(failure),
            ),
        (trivia) => Loaded(trivia: trivia));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
