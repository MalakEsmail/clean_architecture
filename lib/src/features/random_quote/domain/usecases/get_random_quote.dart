import 'package:clean_arch_pro/src/core/error/failures.dart';
import 'package:clean_arch_pro/src/core/usecases/usecase.dart';
import 'package:clean_arch_pro/src/features/random_quote/domain/repositories/quote_repo.dart';
import 'package:dartz/dartz.dart';

import '../entities/quote.dart';

class GetRandomQuoteUseCase implements UseCase<Quote, NoParams> {
  final QuoteRepo quoteRepo;

  GetRandomQuoteUseCase({required this.quoteRepo});

  @override
  Future<Either<Failure, Quote>> call(NoParams params) {
    return quoteRepo.getRandomQuote();
  }
}
