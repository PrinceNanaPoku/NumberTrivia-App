import 'package:flutter/material.dart';

class MessageDisplayed extends StatelessWidget {
  final String message;
  const MessageDisplayed({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // ignore: sized_box_for_whitespace
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Text(
          message,
          style: const TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
