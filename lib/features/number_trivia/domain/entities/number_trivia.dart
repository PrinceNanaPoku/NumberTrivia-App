import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({
    required this.text,
    required this.number,
  }) : super() {
    text;
    number;
  }

  @override
  List<dynamic> get props => [text, number];
}
