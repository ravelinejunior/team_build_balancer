import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:team_build_balancer/src/skills/domain/model/new_player.dart';

class ResultTeamsController {
  late List<List<NewPlayer>> teams;
  Set<String> maleNames = {}; // Set to hold dynamically detected male names

  ResultTeamsController({required List<List<NewPlayer>> initialTeams}) {
    teams = initialTeams;
    _initializeMaleNames();
  }

  /// Shuffle and balance teams by skill and gender
  List<List<NewPlayer>> balanceTeams() {
    List<NewPlayer> allPlayers = teams.expand((team) => team).toList();
    allPlayers.shuffle();

    // Group players by gender for balancing
    List<NewPlayer> males =
        allPlayers.where((player) => _isMale(player.name)).toList();
    List<NewPlayer> females =
        allPlayers.where((player) => !_isMale(player.name)).toList();

    // Calculate the target number of males per team to distribute evenly
    int totalMales = males.length;
    int totalTeams = teams.length;
    int malesPerTeam = totalMales ~/ totalTeams;
    int extraMales = totalMales % totalTeams;

    List<List<NewPlayer>> balancedTeams = [];
    int teamSize = teams[0].length;

    // Initialize empty teams
    for (int i = 0; i < totalTeams; i++) {
      balancedTeams.add([]);
    }

    // Distribute males first
    for (int i = 0; i < totalTeams; i++) {
      int maleCount =
          malesPerTeam + (i < extraMales ? 1 : 0); // Distribute extra males

      for (int j = 0; j < maleCount; j++) {
        if (males.isNotEmpty) {
          balancedTeams[i].add(males.removeLast());
        }
      }
    }

    // Distribute females evenly across teams
    for (int i = 0; i < totalTeams; i++) {
      while (balancedTeams[i].length < teamSize && females.isNotEmpty) {
        balancedTeams[i].add(females.removeLast());
      }
    }

    // Finally, ensure skill balance by adding remaining players by skill value
    allPlayers.sort((a, b) => b.totalSkillValue.compareTo(a.totalSkillValue));
    for (var player in allPlayers) {
      balancedTeams.sort(
          (a, b) => calculateTeamAverage(a).compareTo(calculateTeamAverage(b)));
      for (var team in balancedTeams) {
        if (team.length < teamSize) {
          team.add(player);
          break;
        }
      }
    }

    return balancedTeams;
  }

  /// Dynamically detect male names from the initial teams
  void _initializeMaleNames() {
    for (var team in teams) {
      for (var player in team) {
        if (_detectMaleByCommonPatterns(player.name)) {
          maleNames.add(player.name);
        }
      }
    }
  }

  /// Detect male names based on common patterns
  bool _detectMaleByCommonPatterns(String name) {
    final maleSuffixes = ['o', 'r', 'l', 'n'];
    final femaleSuffixes = ['a', 'e'];

    String lowerName = name.trim().toLowerCase();
    String lastChar = lowerName[lowerName.length - 1];

    if (maleSuffixes.contains(lastChar)) {
      return true;
    } else if (femaleSuffixes.contains(lastChar)) {
      return false;
    }
    return true;
  }

  /// Simplified gender detection based on gathered names
  bool _isMale(String name) {
    return maleNames.contains(name);
  }

  /// Check if two teams are equal (i.e., if the shuffle didn't change the teams)
  bool areTeamsEqual(
      List<List<NewPlayer>> oldTeams, List<List<NewPlayer>> newTeams) {
    for (int i = 0; i < oldTeams.length; i++) {
      if (oldTeams[i].length != newTeams[i].length) return false;
      for (int j = 0; j < oldTeams[i].length; j++) {
        if (oldTeams[i][j].name != newTeams[i][j].name) {
          return false;
        }
      }
    }
    return true;
  }

  /// Calculate the average skill for a team
  double calculateTeamAverage(List<NewPlayer> team) {
    double totalSkill = 0;
    int skillCount = 0;

    for (var player in team) {
      totalSkill += player.skills.values.reduce((a, b) => a + b);
      skillCount += player.skills.length;
    }

    return totalSkill / skillCount;
  }

  /// Export teams as CSV file
  Future<void> exportTeamsAsCSV(List<List<NewPlayer>> teams) async {
    String csvData = _convertTeamsToCSV(teams);

    // Save the CSV to a file
    final directory = await getDownloadsDirectory();
    final file = File('${directory?.absolute.path}/teams.csv');
    await file.writeAsString(csvData);

    debugPrint("Teams exported as CSV to ${file.path}");
  }

  /// Export teams as JSON file
  Future<void> exportTeamsAsJSON(List<List<NewPlayer>> teams) async {
    String jsonData = jsonEncode(_convertTeamsToMap(teams));

    // Save the JSON to a file
    final directory = await getDownloadsDirectory();
    final file = File('${directory?.absolute.path}/teams.json');
    await file.writeAsString(jsonData);

    debugPrint("Teams exported as JSON to ${file.path}");
  }

  /// Convert the teams to CSV format
  String _convertTeamsToCSV(List<List<NewPlayer>> teams) {
    StringBuffer csvBuffer = StringBuffer();

    // Add headers
    csvBuffer.writeln("Team,Player,Total Skill Value");

    // Iterate through the teams and players
    for (int teamIndex = 0; teamIndex < teams.length; teamIndex++) {
      final team = teams[teamIndex];
      for (final player in team) {
        csvBuffer.writeln(
            'Team ${teamIndex + 1},${player.name},${player.totalSkillValue}');
      }
    }

    return csvBuffer.toString();
  }

  /// Convert teams to a Map for JSON export
  List<Map<String, dynamic>> _convertTeamsToMap(List<List<NewPlayer>> teams) {
    return teams.map((team) {
      return {
        'team': team.map((player) {
          return {
            'name': player.name,
            'skills': player.skills,
            'totalSkillValue': player.totalSkillValue,
          };
        }).toList(),
      };
    }).toList();
  }
}
