import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newapp/core/platform/network_info.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:newapp/features/number_trivia/domain/repositories/number_trivia_repository_imp.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImp repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

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
}
