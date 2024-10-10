import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:team_build_balancer/core/dependency_injection/injection_container.dart';
import 'package:team_build_balancer/core/localization/l10n.dart';
import 'package:team_build_balancer/core/res/theme.dart';
import 'package:team_build_balancer/core/route/router.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/player/add_player_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/player/delete_player_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/player/get_players_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/player/update_player_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/add_skill_to_player_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/add_skill_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/delete_skill_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/get_skills_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/update_skill_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/teams/generate_teams_use_case.dart';
import 'package:team_build_balancer/src/skills/presentation/bloc/teams_bloc.dart';
import 'package:team_build_balancer/src/sports/domain/use_cases/get_sport_by_id_use_case.dart';
import 'package:team_build_balancer/src/sports/domain/use_cases/get_sports_use_case.dart';
import 'package:team_build_balancer/src/sports/presentation/bloc/sports_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  ); */
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SportsBloc>(
          create: (context) => SportsBloc(
            getSportsUseCase: serviceLocator<GetSportsUseCase>(),
            getSportByIdUseCase: serviceLocator<GetSportByIdUseCase>(),
          ),
        ),
        BlocProvider<TeamsBloc>(
          create: (context) => TeamsBloc(
            getPlayersUseCase: serviceLocator<GetPlayersUseCase>(),
            getSkillsUseCase: serviceLocator<GetSkillsUseCase>(),
            addPlayerUseCase: serviceLocator<AddPlayerUseCase>(),
            addSkillUseCase: serviceLocator<AddSkillUseCase>(),
            addSkillToPlayerUseCase: serviceLocator<AddSkillToPlayerUseCase>(),
            deletePlayerUseCase: serviceLocator<DeletePlayerUseCase>(),
            deleteSkillUseCase: serviceLocator<DeleteSkillUseCase>(),
            updatePlayerUseCase: serviceLocator<UpdatePlayerUseCase>(),
            updateSkillUseCase: serviceLocator<UpdateSkillUseCase>(),
            generateTeamsUseCase: serviceLocator<GenerateTeamsUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Team Builder Balancer',
        debugShowCheckedModeBanner: false,
        theme: mainThemeData(),
        darkTheme: mainThemeData(),
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('pt', ''), // Portuguese
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) return supportedLocales.first;
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
