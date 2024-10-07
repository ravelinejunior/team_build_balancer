import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_build_balancer/core/dependency_injection/injection_container.dart';
import 'package:team_build_balancer/src/skills/domain/model/new_player.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/presentation/bloc/teams_bloc.dart';
import 'package:team_build_balancer/src/skills/presentation/skills_screen.dart';
import 'package:team_build_balancer/src/skills/presentation/view/player_skill_view.dart';
import 'package:team_build_balancer/src/skills/presentation/view/result_teams.view.dart';
import 'package:team_build_balancer/src/sports/domain/model/sports.dart';
import 'package:team_build_balancer/src/sports/presentation/bloc/sports_bloc.dart';
import 'package:team_build_balancer/src/sports/presentation/views/sports_screen.dart';

part 'router_main.dart';
