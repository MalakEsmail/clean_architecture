import 'package:clean_arch_pro/src/features/random_quote/presentation/random_quote_cubit/random_quote_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/features/random_quote/presentation/home_screen.dart';
import 'injection_container.dart' as inj;
class RandomQuoteApp extends StatelessWidget {
  const RandomQuoteApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(providers: [
        BlocProvider(
          create: (context) =>
          inj.sl<RandomQuoteCubit>(),
          child: const HomeScreen(),
        ),
      ], child: const HomeScreen()),
    );
  }
}
