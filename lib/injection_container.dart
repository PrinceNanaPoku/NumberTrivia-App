import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:newapp/core/network/network_info.dart';
import 'package:newapp/core/util/input_converter.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:newapp/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:newapp/features/number_trivia/domain/repositories/number_trivia_repository_imp.dart';
import 'package:newapp/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:newapp/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //Bloc

  sl.registerFactory(
    () => NumberTriviaBloc(
      getGetConcretNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

//Usecases
  sl.registerLazySingleton(
    () => GetConcreteNumberTrivia(sl()),
  );

  sl.registerLazySingleton(
    () => GetRandomNumberTrivia(sl()),
  );

  // respositoty
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImp(
        remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
