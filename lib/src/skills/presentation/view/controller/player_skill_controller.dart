import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_build_balancer/core/dependency_injection/injection_container.dart';
import 'package:team_build_balancer/src/skills/domain/model/new_player.dart';

class PlayerSkillController extends ChangeNotifier {
  final sharedPreferences = serviceLocator<SharedPreferences>();

  void savePlayerData({
    required List<TextEditingController> playerNameControllers,
    required List<List<TextEditingController>> playerSkillsControllers,
    required List<String> skills,
    required int amountOfPlayers,
  }) async {
    // Prepare data to be saved in JSON format
    List<Map<String, dynamic>> playerData = [];

    for (int i = 0; i < amountOfPlayers; i++) {
      String playerName = playerNameControllers[i].text;
      Map<String, int> playerSkills = {};

      for (int j = 0; j < skills.length; j++) {
        playerSkills[skills[j]] =
            int.tryParse(playerSkillsControllers[i][j].text) ?? 0;
      }

      playerData.add({
        'name': playerName,
        'skills': playerSkills,
      });
    }

    // Save the data as a JSON string
    String jsonData = jsonEncode(playerData);
    await sharedPreferences.setString('playerData', jsonData);
  }

  void loadPlayerData({
    required List<TextEditingController> playerNameControllers,
    required List<List<TextEditingController>> playerSkillsControllers,
    required List<String> skills,
  }) async {
    // Check if there is saved player data
    String? jsonData = sharedPreferences.getString('playerData');
    if (jsonData != null) {
      // Decode JSON data
      List<dynamic> savedPlayerData = jsonDecode(jsonData);

      // Populate controllers with saved data
      for (int i = 0;
          i < savedPlayerData.length && i < playerNameControllers.length;
          i++) {
        Map<String, dynamic> playerInfo = savedPlayerData[i];

        playerNameControllers[i].text = playerInfo['name'];

        for (int j = 0; j < skills.length; j++) {
          playerSkillsControllers[i][j].text =
              playerInfo['skills'][skills[j]].toString();
        }
      }
    }
  }

  void addNewPlayer({
    required List<TextEditingController> playerNameControllers,
    required List<List<TextEditingController>> playerSkillsControllers,
    required List<String> skills,
  }) {
    // Add new player name controller
    playerNameControllers.add(TextEditingController());

    // Add new player skills controllers
    List<TextEditingController> newSkillControllers = [];
    for (int i = 0; i < skills.length; i++) {
      newSkillControllers.add(TextEditingController(text: ""));
    }
    playerSkillsControllers.add(newSkillControllers);
  }

  void deletePlayer({
    required int index,
    required List<TextEditingController> playerNameControllers,
    required List<List<TextEditingController>> playerSkillsControllers,
  }) {
    if (index >= 0 && index < playerNameControllers.length) {
      playerNameControllers.removeAt(index);
      playerSkillsControllers.removeAt(index);
    }
  }

  bool verifyIfAllTextEditingAreFilled(
    List<TextEditingController> playerNameControllers,
    List<List<TextEditingController>> playerSkillsControllers,
  ) {
    for (int i = 0; i < playerNameControllers.length; i++) {
      if (playerNameControllers[i].text.isEmpty) {
        return false;
      }
      for (int j = 0; j < playerSkillsControllers[i].length; j++) {
        if (playerSkillsControllers[i][j].text.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void clearPlayerData(
    List<TextEditingController> playerNameControllers,
    List<List<TextEditingController>> playerSkillsControllers,
  ) {
    sharedPreferences.remove('playerData');
    _clearTextEditingInputs(playerNameControllers, playerSkillsControllers);
  }

  void _clearTextEditingInputs(
    List<TextEditingController> playerNameControllers,
    List<List<TextEditingController>> playerSkillsControllers,
  ) {
    for (int i = 0; i < playerNameControllers.length; i++) {
      playerNameControllers[i].clear();
      for (int j = 0; j < playerSkillsControllers[i].length; j++) {
        playerSkillsControllers[i][j].clear();
      }
    }
  }

  // Generate teams based on player skill levels
  List<List<NewPlayer>> generateTeams({
    required List<NewPlayer> players,
    required int numTeams,
    Map<String, double>? skillWeights,
  }) {
    // Recalculate total skill value for each player based on skill weights
    if (skillWeights != null) {
      players = players.map((player) {
        double totalSkillValue = player.skills.entries
            .map((e) => (e.value * (skillWeights[e.key] ?? 1.0)))
            .reduce((a, b) => a + b);
        player.totalSkillValue = totalSkillValue;
        return player;
      }).toList();
    }

    // Sort players by their total skill value in descending order
    players.sort((a, b) => b.totalSkillValue.compareTo(a.totalSkillValue));

    // Initialize empty lists for the teams
    List<List<NewPlayer>> teams = List.generate(numTeams, (_) => []);

    // Distribute players using a "snake draft" pattern
    bool reverse = false;
    int teamIndex = 0;

    for (var player in players) {
      teams[teamIndex].add(player);

      if (reverse) {
        teamIndex--;
        if (teamIndex < 0) {
          reverse = false;
          teamIndex = 0;
        }
      } else {
        teamIndex++;
        if (teamIndex >= numTeams) {
          reverse = true;
          teamIndex = numTeams - 1;
        }
      }
    }

    // Balance the teams after initial distribution
    _balanceTeams(teams);

    return teams;
  }

  // Helper function to balance teams based on skill levels
  void _balanceTeams(List<List<NewPlayer>> teams) {
    // Calculate total skill value for each team
    List<double> teamSkillValues = teams
        .map((team) =>
            team.fold(0.0, (total, player) => total + (player.totalSkillValue)))
        .toList();

    // Calculate the average skill value for all teams
    double totalSkill = teamSkillValues.reduce((a, b) => a + b);
    double avgSkillValue = totalSkill / teams.length;

    // Check if any team exceeds the 20% margin and needs balancing
    for (int i = 0; i < teams.length; i++) {
      if (teamSkillValues[i] > avgSkillValue * 1.2) {
        for (int j = 0; j < teams.length; j++) {
          if (teamSkillValues[j] < avgSkillValue * 0.8) {
            _swapPlayersToBalance(teams[i], teams[j], avgSkillValue);
            break;
          }
        }
      }
    }
  }

// Helper function to swap players between two teams for better balance
  void _swapPlayersToBalance(
      List<NewPlayer> teamA, List<NewPlayer> teamB, double avgSkillValue) {
    // Sort teamA in ascending order of totalSkillValue and teamB in descending order
    teamA.sort((a, b) => a.totalSkillValue.compareTo(b.totalSkillValue));
    teamB.sort((a, b) => b.totalSkillValue.compareTo(a.totalSkillValue));

    // Try to find the best swap between teams
    for (int i = 0; i < teamA.length && i < teamB.length; i++) {
      double skillDiff = teamB[i].totalSkillValue;

      // Swap players if the skill difference is reasonable
      if (skillDiff > 0 && skillDiff < avgSkillValue) {
        NewPlayer temp = teamA[i];
        teamA[i] = teamB[i];
        teamB[i] = temp;
        break;
      }
    }
  }

  Future importFromClipboard({
    required List<TextEditingController> playerNameControllers,
    required BuildContext context,
  }) async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null) {
      String clipboardText = clipboardData.text ?? '';

      // Extract names using regular expressions
      RegExp regex = RegExp(r'\d+\-\s*([A-Za-zÀ-ÿ ]+)', multiLine: true);
      Iterable<RegExpMatch> matches = regex.allMatches(clipboardText);

      // Create a list of names from the matches
      List<String> importedNames =
          matches.map((match) => match.group(1)!.trim()).toList();

      // Populate the player name controllers with extracted names
      for (int i = 0;
          i < importedNames.length && i < playerNameControllers.length;
          i++) {
        playerNameControllers[i].text = importedNames[i];
      }

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Close dialog
    }
  }
}
