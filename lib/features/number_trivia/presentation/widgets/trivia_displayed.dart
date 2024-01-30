import 'package:flutter/material.dart';

class TriviaDisplayed extends StatelessWidget {
  final NumberTrivia numberTrivia;
  const TriviaDisplayed({
    required this.numberTrivia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            numberTrivia.text.toString(),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTrivia.text,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
