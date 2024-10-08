import 'package:flutter/material.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
import 'package:team_build_balancer/src/skills/domain/model/new_player.dart';

class ResultTeamsView extends StatefulWidget {
  static const String routeName = '/results';

  final List<List<NewPlayer>> initialTeams;

  const ResultTeamsView({Key? key, required this.initialTeams})
      : super(key: key);

  @override
  State<ResultTeamsView> createState() => _ResultTeamsViewState();
}

class _ResultTeamsViewState extends State<ResultTeamsView> {
  late List<List<NewPlayer>> teams;
  Set<String> maleNames = {}; // Set to hold dynamically detected male names

  @override
  void initState() {
    super.initState();
    teams = widget.initialTeams;
    _initializeMaleNames(); // Initialize the male names based on initial data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teams Result"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, teamIndex) {
          final team = teams[teamIndex];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  'Team ${teamIndex + 1}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: team.length,
                  itemBuilder: (context, playerIndex) {
                    final player = team[playerIndex];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(player.name[0]), // Player initial as avatar
                      ),
                      title: Text(player.name),
                      subtitle: Text(
                        'Total Skill Value: ${player.totalSkillValue}',
                      ),
                    );
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Average Skill: ${_calculateTeamAverage(team).toStringAsFixed(2)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reshuffleTeams,
        tooltip: 'Reshuffle Teams',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // Calculate the average skill for a team
  double _calculateTeamAverage(List<NewPlayer> team) {
    double totalSkill = 0;
    int skillCount = 0;

    for (var player in team) {
      totalSkill += player.skills.values.reduce((a, b) => a + b);
      skillCount += player.skills.length;
    }

    return totalSkill / skillCount;
  }

  // Function to reshuffle players across teams while keeping them balanced
  void _reshuffleTeams() {
    setState(() {
      List<List<NewPlayer>> shuffledTeams = _balanceTeams(teams);
      if (_areTeamsEqual(teams, shuffledTeams)) {
        CoreUtils.showSnackBar(context, 'Teams are already balanced!');
      } else {
        teams = shuffledTeams;
      }
    });
  }

  /// Check if two teams are equal (i.e., if the shuffle didn't change the teams)
  bool _areTeamsEqual(
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

  /// Shuffle and balance teams by skill and gender
  List<List<NewPlayer>> _balanceTeams(List<List<NewPlayer>> teams) {
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
      balancedTeams.sort((a, b) =>
          _calculateTeamAverage(a).compareTo(_calculateTeamAverage(b)));
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
    // Assume common name endings and patterns to infer gender
    for (var team in teams) {
      for (var player in team) {
        if (_detectMaleByCommonPatterns(player.name)) {
          maleNames.add(player.name);
        }
      }
    }
  }

  /// Detect male names based on common patterns in Brazilian/Portuguese names
  bool _detectMaleByCommonPatterns(String name) {
    // List of common male name suffixes in Brazilian/Portuguese names
    final maleSuffixes = [
      'o',
      'r',
      'l',
      'n'
    ]; // João, Pedro, Rafael, Thiago, etc.
    final femaleSuffixes = ['a', 'e']; // Ana, Beatriz, etc.

    // Basic assumption: names ending in "o", "r", "l", "n" are male
    String lowerName = name.trim().toLowerCase();
    String lastChar = lowerName[lowerName.length - 1];

    if (maleSuffixes.contains(lastChar)) {
      return true;
    } else if (femaleSuffixes.contains(lastChar)) {
      return false;
    }

    // If the pattern does not match, default to male (for simplicity)
    return true;
  }

  /// Simplified gender detection based on dynamically gathered names
  bool _isMale(String name) {
    return maleNames.contains(name);
  }
}
