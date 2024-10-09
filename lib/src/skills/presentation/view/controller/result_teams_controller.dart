import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:team_build_balancer/src/skills/domain/model/new_player.dart';

class ResultTeamsController {
  late List<List<NewPlayer>> teams;
  Set<String> maleNames = {}; // Set to hold dynamically detected male names

  ResultTeamsController({required List<List<NewPlayer>> initialTeams}) {
    teams = initialTeams;
    _initializeMaleNames();
  }

  /// Shuffle and balance teams by skill and gender
  List<List<NewPlayer>> balancesTeams() {
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

  List<List<NewPlayer>> balanceTeams() {
  List<NewPlayer> allPlayers = teams.expand((team) => team).toList();
  allPlayers.shuffle();

  // Group players by gender for balancing
  List<NewPlayer> males = allPlayers.where((player) => _isMale(player.name)).toList();
  List<NewPlayer> females = allPlayers.where((player) => !_isMale(player.name)).toList();

  // Total players and teams
  int totalPlayers = allPlayers.length;
  int totalTeams = teams.length;

  // Calculate the target number of players per team
  int playersPerTeam = totalPlayers ~/ totalTeams;
  int extraPlayers = totalPlayers % totalTeams; // This represents the remainder, at most one team should have one extra player.

  List<List<NewPlayer>> balancedTeams = [];

  // Initialize empty teams
  for (int i = 0; i < totalTeams; i++) {
    balancedTeams.add([]);
  }

  // Ensure each team has playersPerTeam players, except for some having one extra
  int teamIndex = 0;

  // Distribute males first, then females, while maintaining the correct number of players per team
  List<NewPlayer> remainingPlayers = males + females; // Combine males and females for final distribution

  for (var player in remainingPlayers) {
    // Allow the first `extraPlayers` teams to get one additional player
    if (balancedTeams[teamIndex].length < playersPerTeam + (teamIndex < extraPlayers ? 1 : 0)) {
      balancedTeams[teamIndex].add(player);
    }

    // Move to the next team
    teamIndex = (teamIndex + 1) % totalTeams;
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

  /// Share teams as a text message via WhatsApp
  Future<void> shareTeamsToWhatsApp(List<List<NewPlayer>> teams) async {
    String teamsText = _convertTeamsToText(teams);
    await Share.share(teamsText, subject: 'Balanced Teams');
  }

  /// Convert the teams to a text format for sharing via WhatsApp
  String _convertTeamsToText(List<List<NewPlayer>> teams) {
    StringBuffer textBuffer = StringBuffer();

    // Iterate through the teams and players
    for (int teamIndex = 0; teamIndex < teams.length; teamIndex++) {
      textBuffer.writeln("Team ${teamIndex + 1}:");
      final team = teams[teamIndex];
      for (final player in team) {
        textBuffer
            .writeln('${player.name} (Total Skill: ${player.totalSkillValue})');
      }
      textBuffer.writeln(); // Add a blank line between teams
    }

    return textBuffer.toString();
  }

  /// Export teams as CSV file into the Downloads folder
  Future<void> exportTeamsAsCSV(List<List<NewPlayer>> teams) async {
    // Request storage permission
    if (await _requestStoragePermission()) {
      // Get the path to the Downloads folder
      final directory = await getDownloadsDirectory();

      if (directory != null) {
        // Create the CSV content
        String csvData = _convertTeamsToCSV(teams);

        // Create the file path and write the file
        final filePath = '${directory.path}/teams.csv';
        final file = File(filePath);
        await file.writeAsString(csvData);

        debugPrint("Teams exported as CSV to $filePath");
      } else {
        debugPrint("Downloads directory not found");
      }
    } else {
      debugPrint("Permission to write to storage denied");
    }
  }

  /// Export teams as CSV file into the Downloads folder
  Future<void> exportTeamsAsJson(List<List<NewPlayer>> teams) async {
    // Request storage permission
    if (await _requestStoragePermission()) {
      // Get the path to the Downloads folder
      final directory = await getDownloadsDirectory();

      if (directory != null) {
        // Create the CSV content
          String jsonData = jsonEncode(_convertTeamsToMap(teams));

        // Create the file path and write the file
        final filePath = '${directory.path}/teams.json';
        final file = File(filePath);
        await file.writeAsString(jsonData);

        debugPrint("Teams exported as Json to $filePath");
      } else {
        debugPrint("Downloads directory not found");
      }
    } else {
      debugPrint("Permission to write to storage denied");
    }
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

  /// Request storage permission
  Future<bool> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Get the Downloads directory for the device
  Future<Directory?> getDownloadsDirectory() async {
    // This uses path_provider to get the external storage directory, then appends "Download"
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      // For iOS, use the app's document directory
      return await getApplicationDocumentsDirectory();
    }
    return null;
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
