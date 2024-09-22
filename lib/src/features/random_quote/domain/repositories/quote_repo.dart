import 'package:clean_arch_pro/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/quote.dart';
abstract class QuoteRepo{
  Future<Either<Failure, Quote>> getRandomQuote();
}