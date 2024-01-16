import 'package:dartz/dartz.dart';
import 'package:newapp/core/error/failure.dart';
import 'package:newapp/core/platform/network_info.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:newapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:newapp/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImp implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int? number) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
