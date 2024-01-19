import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newapp/core/error/exceptions.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:newapp/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });
  group('LocalNumberTrivia', () {
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        fixture('triva_cache.json'),
      ),
    );
    test(
        "should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async {
      //arrange
      when(mockSharedPreferences.getString(''))
          .thenReturn(fixture('trivia_cache.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();
      //assert
      verify(mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(testNumberTriviaModel));
    });

    test("should throw a cache exception when there is not a cached value",
        () async {
      //arrange
      when(mockSharedPreferences.getString('')).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cache number trivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel(text: 'test triva', number: 1);
    test('should call shared preferences to cache', () async {
      //act
      dataSource.cacheNumberTrivia(testNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(testNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          cachedNumberTrivia, expectedJsonString));
    });
  });
}
