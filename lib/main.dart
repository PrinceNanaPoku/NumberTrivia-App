import 'package:flutter/material.dart';
import 'package:newapp/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:newapp/injection_container.dart' as dl;

void main() async {
  await dl.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
