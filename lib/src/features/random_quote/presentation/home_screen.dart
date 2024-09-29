import 'package:clean_arch_pro/src/core/error/failures.dart';
import 'package:clean_arch_pro/src/features/random_quote/presentation/random_quote_cubit/random_quote_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_arch_pro/injection_container.dart' as inj;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _getRandomQuote();
    super.initState();
  }

  _getRandomQuote() {
    context.read<RandomQuoteCubit>().getRandomQuoteFunction();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            BlocConsumer<RandomQuoteCubit, RandomQuoteState>(
                listener: (context, state) {},
                builder: (context, state) {
                  print("state:$state");
                  if (state is RandomQuoteError) {
                    return Text(state.msg);
                  } else if (state is RandomQuoteLoaded) {
                    return Text(state.quote.content);
                  }
                  return const Text('No Content');
                }),
          ],
        ),
      ),
    );
  }
}
