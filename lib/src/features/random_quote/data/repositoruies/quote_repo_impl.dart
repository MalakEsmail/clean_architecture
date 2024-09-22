import 'package:clean_arch_pro/src/core/error/exceptions.dart';
import 'package:clean_arch_pro/src/core/error/failures.dart';
import 'package:clean_arch_pro/src/core/network/network_info.dart';
import 'package:clean_arch_pro/src/features/random_quote/domain/entities/quote.dart';
import 'package:clean_arch_pro/src/features/random_quote/domain/repositories/quote_repo.dart';
import 'package:dartz/dartz.dart';

import '../data_source/random_quote_local_data_source.dart';
import '../data_source/random_quote_remote_data_source.dart';

class QuoteRepoImpl implements QuoteRepo {
  final NetworkInfo networkInfo;
  final RandomQuoteRemoteDataSource remoteDataSource;
  final RandomQuoteLocalDataSource randomQuoteLocalDataSource;

  QuoteRepoImpl({required this.networkInfo, required this.randomQuoteLocalDataSource, required this.remoteDataSource});

  @override
  Future<Either<Failure, Quote>> getRandomQuote() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRandomQuote = await remoteDataSource.getRandomQuote();

        await randomQuoteLocalDataSource.cacheQuote(remoteRandomQuote);

        return Right(remoteRandomQuote);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localRandomQuote = await randomQuoteLocalDataSource.getLastRandomQuote();

        return Right(localRandomQuote);
      } on CacheException {
        return Left(CashFailure());
      }
    }
  }
}
