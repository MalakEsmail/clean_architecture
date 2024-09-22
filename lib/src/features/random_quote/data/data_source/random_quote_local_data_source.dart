import 'dart:convert';

import 'package:clean_arch_pro/src/core/error/exceptions.dart';
import 'package:clean_arch_pro/src/core/utils/app_strings.dart';
import 'package:clean_arch_pro/src/features/random_quote/data/model/quote_modell.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RandomQuoteLocalDataSource {
  Future<QuoteModel> getLastRandomQuote();

  Future<void> cacheQuote(QuoteModel quoteModel);
}

class RandomQuoteLocalDataSourceImpl implements RandomQuoteLocalDataSource {
  final SharedPreferences sharedPref;

  RandomQuoteLocalDataSourceImpl({required this.sharedPref});

  @override
  Future<void> cacheQuote(QuoteModel quoteModel) {
    return sharedPref.setString(
        AppStrings.cachedRandomQuote, jsonEncode(quoteModel));
  }

  @override
  Future<QuoteModel> getLastRandomQuote() {
    final jsonString = sharedPref.getString(AppStrings.cachedRandomQuote);
    if (jsonString != null) {
      final cachedRandomQuote =
          Future.value(QuoteModel.fromJson(jsonDecode(jsonString)));
      return cachedRandomQuote;
    } else {
      throw CacheException();
    }
  }
}
