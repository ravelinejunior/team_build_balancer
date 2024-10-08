import 'dart:math';

import 'package:flutter/material.dart';
import 'package:team_build_balancer/src/skills/domain/model/new_player.dart';

class ResultTeamsController extends ChangeNotifier {
  List<List<NewPlayer>> teams = [];

  void setTeams(List<List<NewPlayer>> newTeams) {
    teams = newTeams;
    notifyListeners();
  }

  /// Swap random players between teams while keeping the balance
  List<List<NewPlayer>> _swapRandomPlayers(List<List<NewPlayer>> teams) {
    Random random = Random();

    // Ensure there are at least two teams to swap players between
    if (teams.length < 2) return teams;

    // Randomly select two different teams
    int teamIndex1 = random.nextInt(teams.length);
    int teamIndex2 = random.nextInt(teams.length);
    while (teamIndex2 == teamIndex1) {
      teamIndex2 = random.nextInt(teams.length);
    }

    // Ensure both teams have players to swap
    if (teams[teamIndex1].isEmpty || teams[teamIndex2].isEmpty) return teams;

    // Randomly select one player from each team
    int playerIndex1 = random.nextInt(teams[teamIndex1].length);
    int playerIndex2 = random.nextInt(teams[teamIndex2].length);

    // Swap the players
    NewPlayer temp = teams[teamIndex1][playerIndex1];
    teams[teamIndex1][playerIndex1] = teams[teamIndex2][playerIndex2];
    teams[teamIndex2][playerIndex2] = temp;

    // Ensure the balance is maintained after swapping
    if (!_areTeamsBalanced(teams)) {
      // Revert the swap if the teams are no longer balanced
      teams[teamIndex2][playerIndex2] = teams[teamIndex1][playerIndex1];
      teams[teamIndex1][playerIndex1] = temp;
    }

    return teams;
  }

  /// Check if teams are still balanced after swapping players
  bool _areTeamsBalanced(List<List<NewPlayer>> teams) {
    List<double> teamAverages = [];

    // Calculate average skill for each team
    for (var team in teams) {
      double totalSkill = 0;
      int skillCount = 0;

      for (var player in team) {
        totalSkill += player.skills.values.reduce((a, b) => a + b);
        skillCount += player.skills.length;
      }

      teamAverages.add(totalSkill / skillCount);
    }

    // Ensure the difference between the best and worst team is acceptable
    double maxAverage = teamAverages.reduce(max);
    double minAverage = teamAverages.reduce(min);

    return (maxAverage - minAverage) <= 1.5; // Threshold for balance
  }

  double calculateTeamAverage(List<NewPlayer> team) {
    double totalSkillValue = 0;
    int totalSkills = 0;

    for (var player in team) {
      totalSkillValue += player.totalSkillValue;
      totalSkills += player.skills.length;
    }

    return totalSkills > 0 ? totalSkillValue / totalSkills : 0.0;
  }
}
