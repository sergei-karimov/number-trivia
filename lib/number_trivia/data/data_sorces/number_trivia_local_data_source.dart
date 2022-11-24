import 'dart:convert';

import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(cachedNumberTrivia, jsonEncode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final lastNumberTrivia = sharedPreferences.getString(cachedNumberTrivia);

    if (lastNumberTrivia != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(lastNumberTrivia)));
    } else {
      throw CacheException();
    }
  }
}