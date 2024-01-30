import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import '../../../../injection_container.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_displayed.dart';
import '../widgets/trivia_controls.dart';
import '../widgets/trivia_displayed.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NumberTrivia'),
      ),
      body: const SingleChildScrollView(child: BuildBody()),
    );
  }
}

class BuildBody extends StatelessWidget {
  const BuildBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    const MessageDisplayed(
                      message: 'Start Searching',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplayed(numberTrivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplayed(message: state.message);
                  }
                  throw '';
                },
              ),

              const SizedBox(
                height: 20,
              ),
              //Bottom half
              const TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
