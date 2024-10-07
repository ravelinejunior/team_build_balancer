import 'package:flutter/material.dart';
import 'package:team_build_balancer/src/sports/domain/model/sports.dart';

import 'view/skill_input_view.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({required this.sport, Key? key}) : super(key: key);
  final SportsModel sport;
  static const String routeName = '/skills';

  @override
  Widget build(BuildContext context) {
    return SkillInputView(
      sport: sport,
    );
  }
}
