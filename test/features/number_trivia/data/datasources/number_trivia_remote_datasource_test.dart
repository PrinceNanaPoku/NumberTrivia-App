import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/core/error/exceptions.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:newapp/features/number_trivia/data/model/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(Uri.parse('http://example.com/api/'),
            headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(Uri.parse('http://example.com/api/'),
            headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('GetConcreteNumberTrivia', () {
    const testNumber = 1;
    final testNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(
      fixture('trivia.json'),
    ));

    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();

      //act
      dataSource.getConcreteNumberTrivia(testNumber);
      //assert
      verify(
        mockHttpClient
            .get(Uri.parse('http://numbersapi.com/$testNumber'), headers: {
          'Content-Type': 'application/json',
        }),
      );
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getConcreteNumberTrivia(testNumber);

      //assert
      expect(result, testNumberTriviaModel);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getConcreteNumberTrivia;

      //assert
      expect(() => call(testNumber),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  //getRandomNumberTrivia
  group('GetRandomNumberTrivia', () {
    final testNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(
      fixture('trivia.json'),
    ));

    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();

      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(
        mockHttpClient.get(Uri.parse('http://numbersapi.com/random'), headers: {
          'Content-Type': 'application/json',
        }),
      );
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getRandomNumberTrivia();

      //assert
      expect(result, testNumberTriviaModel);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getRandomNumberTrivia;

      //assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
