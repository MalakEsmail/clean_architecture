part of 'random_quote_cubit.dart';

@immutable
abstract class RandomQuoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RandomQuoteInitial extends RandomQuoteState {}

class RandomQuoteIsLoading extends RandomQuoteState {}

class RandomQuoteLoaded extends RandomQuoteState {
  final Quote quote;

  RandomQuoteLoaded({required this.quote});

  @override
  List<Object?> get props => [quote];
}

class RandomQuoteError extends RandomQuoteState {
  final String msg;

  RandomQuoteError({required this.msg});

  @override
  List<Object?> get props => [msg];
}
