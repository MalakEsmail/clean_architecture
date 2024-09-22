import 'dart:convert';

import 'package:clean_arch_pro/src/core/api/api_consumer.dart';
import 'package:clean_arch_pro/src/core/api/end_points.dart';
import 'package:clean_arch_pro/src/core/error/exceptions.dart';
import 'package:clean_arch_pro/src/core/utils/app_strings.dart';
import 'package:clean_arch_pro/src/features/random_quote/data/model/quote_modell.dart';
import 'package:http/http.dart' as http;

abstract class RandomQuoteRemoteDataSource {
  Future<QuoteModel> getRandomQuote();
}

class RandomQuoteRemoteDataSourceImpl implements RandomQuoteRemoteDataSource {
  final ApiConsumer client;

  RandomQuoteRemoteDataSourceImpl({required this.client});

  @override
  Future<QuoteModel> getRandomQuote() async {
    final response = await client.get(
      EndPoints.randomQuote,
    );
    return QuoteModel.fromJson(response);
  }
}
