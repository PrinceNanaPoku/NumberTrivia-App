import 'package:dartz/dartz.dart';
import 'package:newapp/core/error/failure.dart';
import 'package:newapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:newapp/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:newapp/features/number_trivia/domain/usecases/usecase.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParam> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParam params) async {
    return await repository.getRandomNumberTrivia();
  }
}
