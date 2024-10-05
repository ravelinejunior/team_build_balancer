import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_build_balancer/core/dependency_injection/injection_container_main.dart';
import 'package:team_build_balancer/core/res/theme.dart';
import 'package:team_build_balancer/core/route/router.dart';
import 'package:team_build_balancer/src/sports/domain/use_cases/get_sport_by_id_use_case.dart';
import 'package:team_build_balancer/src/sports/domain/use_cases/get_sports_use_case.dart';
import 'package:team_build_balancer/src/sports/presentation/bloc/sports_bloc.dart';
import 'package:team_build_balancer/src/sports/presentation/views/sports_screen.dart';

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
    return BlocProvider<SportsBloc>(
      create: (context) => SportsBloc(
        getSportsUseCase: serviceLocator<GetSportsUseCase>(),
        getSportByIdUseCase: serviceLocator<GetSportByIdUseCase>(),
      ),
      child: MaterialApp(
        title: 'Team Builder Balancer',
        debugShowCheckedModeBanner: false,
        theme: mainThemeData(),
        darkTheme: mainThemeData(),
        themeMode: ThemeMode.system,
        initialRoute: SportsScreen.routeName,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
