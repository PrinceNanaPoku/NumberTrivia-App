import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure({List<dynamic> properties = const <dynamic>[]}) : super() {
    properties;
  }
}
