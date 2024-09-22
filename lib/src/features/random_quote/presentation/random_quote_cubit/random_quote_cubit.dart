import 'package:clean_arch_pro/src/core/error/failures.dart';
import 'package:clean_arch_pro/src/core/usecases/usecase.dart';
import 'package:clean_arch_pro/src/core/utils/app_strings.dart';
import 'package:clean_arch_pro/src/features/random_quote/domain/entities/quote.dart';
import 'package:clean_arch_pro/src/features/random_quote/domain/usecases/get_random_quote.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'random_quote_state.dart';

class RandomQuoteCubit extends Cubit<RandomQuoteState> {
  final GetRandomQuoteUseCase getRandomQuoteUseCase;

  RandomQuoteCubit(this.getRandomQuoteUseCase) : super(RandomQuoteInitial());

  Future<void> getRandomQuoteFunction() async {
    emit(RandomQuoteIsLoading());
    Either<Failure, Quote> response = await getRandomQuoteUseCase.call(NoParams());
    emit(response.fold((failure) => RandomQuoteError(msg: _mapFailureToString(failure)), (quote) => RandomQuoteLoaded(quote: quote)));
  }

  _mapFailureToString(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure():
        return AppStrings.serverFailure;
      case CashFailure():
        return AppStrings.cacheFailure;
      default:
        return AppStrings.unExpectedError;
    }
  }
}
