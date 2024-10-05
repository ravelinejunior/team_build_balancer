import 'package:get_it/get_it.dart';
import 'package:team_build_balancer/src/sports/data/data_source/sports_data_source.dart';
import 'package:team_build_balancer/src/sports/data/repository_impl/repository_impl.dart';
import 'package:team_build_balancer/src/sports/domain/repository/sports_repository.dart';
import 'package:team_build_balancer/src/sports/domain/use_cases/get_sport_by_id_use_case.dart';
import 'package:team_build_balancer/src/sports/domain/use_cases/get_sports_use_case.dart';
import 'package:team_build_balancer/src/sports/presentation/bloc/sports_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await _initSports();
}

Future<void> _initSports() async {
  serviceLocator
    ..registerFactory(
      () => SportsBloc(
        getSportsUseCase: serviceLocator(),
        getSportByIdUseCase: serviceLocator(),
      ),
    )
    ..registerFactory<SportsRepository>(
        () => SportsRepositoryImpl(serviceLocator()))
    ..registerLazySingleton(
      () => GetSportsUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => GetSportByIdUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory<SportsDataSource>(
      () => SportsDataSourceImpl(),
    );
}
