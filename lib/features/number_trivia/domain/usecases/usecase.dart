import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:newapp/core/error/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParam extends Equatable {
  @override
  List<dynamic> get props => [];
}
