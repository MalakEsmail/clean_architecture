import 'package:clean_arch_pro/src/core/api/api_consumer.dart';
import 'package:clean_arch_pro/src/core/api/api_interceptor.dart';
import 'package:clean_arch_pro/src/core/api/dio_consumer.dart';
import 'package:clean_arch_pro/src/core/network/network_info.dart';
import 'package:clean_arch_pro/src/features/random_quote/data/data_source/random_quote_local_data_source.dart';
import 'package:clean_arch_pro/src/features/random_quote/data/data_source/random_quote_remote_data_source.dart';
import 'package:clean_arch_pro/src/features/random_quote/data/repositoruies/quote_repo_impl.dart';
import 'package:clean_arch_pro/src/features/random_quote/domain/repositories/quote_repo.dart';
import 'package:clean_arch_pro/src/features/random_quote/domain/usecases/get_random_quote.dart';
import 'package:clean_arch_pro/src/features/random_quote/presentation/random_quote_cubit/random_quote_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;
// call when project start
Future<void> init() async {
  /// features
  // bloc
  // registerFactory create new instance when use
  sl.registerFactory(() => RandomQuoteCubit(sl.call()));
  // use cases
  sl.registerLazySingleton(() => GetRandomQuoteUseCase(quoteRepo: sl.call()));
  // repo
  sl.registerLazySingleton<QuoteRepo>(
      () => QuoteRepoImpl(networkInfo: sl.call(), randomQuoteLocalDataSource: sl.call(), remoteDataSource: sl.call()));
// data source
  sl.registerLazySingleton<RandomQuoteLocalDataSource>(() => RandomQuoteLocalDataSourceImpl(sharedPref: sl.call()));
  sl.registerLazySingleton<RandomQuoteRemoteDataSource>(() => RandomQuoteRemoteDataSourceImpl(client: sl.call()));

  /// core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnectionChecker: sl.call()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(
        client: sl.call(),
      ));

  /// external
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => AppIntercepters());
  sl.registerLazySingleton(
      () => LogInterceptor(request: true, requestBody: true, requestHeader: true, responseBody: true, responseHeader: true, error: true));
}
