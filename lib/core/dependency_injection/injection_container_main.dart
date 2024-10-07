part of 'injection_container.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await _initSports();
  await initTeams();
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

Future<void> initTeams() async {
  serviceLocator
    ..registerFactory(
      () => TeamsBloc(
        getPlayersUseCase: serviceLocator(),
        getSkillsUseCase: serviceLocator(),
        addPlayerUseCase: serviceLocator(),
        addSkillUseCase: serviceLocator(),
        addSkillToPlayerUseCase: serviceLocator(),
        deletePlayerUseCase: serviceLocator(),
        deleteSkillUseCase: serviceLocator(),
        updatePlayerUseCase: serviceLocator(),
        updateSkillUseCase: serviceLocator(),
        generateTeamsUseCase: serviceLocator(),
      ),
    )
    ..registerFactory<TeamRepository>(
      () => TeamRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => GetPlayersUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => GetSkillsUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => GenerateTeamsUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AddSkillToPlayerUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AddPlayerUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AddSkillUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => DeletePlayerUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => DeleteSkillUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => UpdatePlayerUseCase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => UpdateSkillUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory<TeamsDataSource>(
      () => TeamsDataSourceImpl(),
    );
}
