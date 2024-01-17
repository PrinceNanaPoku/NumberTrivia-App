import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newapp/core/error/exceptions.dart';
import 'package:newapp/core/error/failure.dart';
import 'package:newapp/core/platform/network_info.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:newapp/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:newapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:newapp/features/number_trivia/domain/repositories/number_trivia_repository_imp.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImp repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImp(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  //GetConcreteNumberTrivia Test

  group(
    'getConcreteNumberTrivia',
    () {
      const testNumber = 1;
      final testNumberTriviaModel =
          NumberTriviaModel(text: "test trivia", number: testNumber);
      final NumberTrivia testNumberTrivia = testNumberTriviaModel;

      test(
        "check if device is online",
        () async {
          //arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          //act
          repository.getConcreteNumberTrivia(testNumber);
          //assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      runTestOnline(
        () {
          test(
            'Should return remote data when the call to remote data source is successful',
            () async {
              //arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenAnswer((_) async => testNumberTriviaModel);
              //act
              final result =
                  await repository.getConcreteNumberTrivia(testNumber);
              //assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
              expect(
                result,
                equals(
                  Right(testNumberTrivia),
                ),
              );
            },
          );

          test(
            'Should cache the data locally when the call to remote data source is successful',
            () async {
              //arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenAnswer((_) async => testNumberTriviaModel);
              //act
              await repository.getConcreteNumberTrivia(testNumber);
              //assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(
                testNumber,
              ));
              verify(mockLocalDataSource.cacheNumberTrivia(
                testNumberTriviaModel,
              ));
            },
          );

          test(
            'Should return server failure when the call to remote data source is unsuccessful',
            () async {
              //arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenThrow(ServerException());
              //act
              final result =
                  await repository.getConcreteNumberTrivia(testNumber);
              //assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
              verifyZeroInteractions(mockLocalDataSource);
              expect(
                result,
                equals(
                  const Left(ServerFailure),
                ),
              );
            },
          );
        },
      );
      runTestOffline(
        () {
          test(
              'should return last locally cached data when the cached data is present',
              () async {
            //arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => testNumberTriviaModel);
            //act
            final result = await repository.getConcreteNumberTrivia(testNumber);
            //assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(
              result,
              equals(
                Right(testNumberTrivia),
              ),
            );
          });

          test(
              'should return CacheFailure when there is no cached data present',
              () async {
            //arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result = await repository.getConcreteNumberTrivia(testNumber);
            //assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(
              result,
              equals(
                const Left(CacheFailure),
              ),
            );
          });
        },
      );
    },
  );

//GetRandomNumberTrivia Test
  group(
    'getRandomNumberTrivia',
    () {
      final testNumberTriviaModel =
          NumberTriviaModel(text: "test trivia", number: 123);
      final NumberTrivia testNumberTrivia = testNumberTriviaModel;

      test(
        "check if device is online",
        () async {
          //arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          //act
          repository.getRandomNumberTrivia();
          //assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      runTestOnline(
        () {
          test(
            'Should return remote data when the call to remote data source is successful',
            () async {
              //arrange
              when(mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => testNumberTriviaModel);
              //act
              final result = await repository.getRandomNumberTrivia();
              //assert
              verify(mockRemoteDataSource.getRandomNumberTrivia());
              expect(
                result,
                equals(
                  Right(testNumberTrivia),
                ),
              );
            },
          );

          test(
            'Should cache the data locally when the call to remote data source is successful',
            () async {
              //arrange
              when(mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => testNumberTriviaModel);
              //act
              await repository.getRandomNumberTrivia();
              //assert
              verify(mockRemoteDataSource.getRandomNumberTrivia());
              verify(mockLocalDataSource.cacheNumberTrivia(
                testNumberTriviaModel,
              ));
            },
          );

          test(
            'Should return server failure when the call to remote data source is unsuccessful',
            () async {
              //arrange
              when(mockRemoteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());
              //act
              final result = await repository.getRandomNumberTrivia();
              //assert
              verify(mockRemoteDataSource.getRandomNumberTrivia());
              verifyZeroInteractions(mockLocalDataSource);
              expect(
                result,
                equals(
                  const Left(ServerFailure),
                ),
              );
            },
          );
        },
      );
      runTestOffline(
        () {
          test(
              'should return last locally cached data when the cached data is present',
              () async {
            //arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => testNumberTriviaModel);
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(
              result,
              equals(
                Right(testNumberTrivia),
              ),
            );
          });

          test(
              'should return CacheFailure when there is no cached data present',
              () async {
            //arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(
              result,
              equals(
                const Left(CacheFailure),
              ),
            );
          });
        },
      );
    },
  );
}
