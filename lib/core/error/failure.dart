import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure({List<dynamic> properties = const <dynamic>[]}) : super() {
    properties;
  }
}

class ServerFailure extends Failure {
  @override
  List<dynamic> get props => throw UnimplementedError();
}

class CacheFailure extends Failure {
  @override
  List<dynamic> get props => throw UnimplementedError();
}
