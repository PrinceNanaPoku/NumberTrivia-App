import 'package:dartz/dartz.dart';
import 'package:newapp/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call();
}

