import 'dart:math';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize with the initially generated teams
    teams = widget.initialTeams;
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
                      subtitle:
                          Text('Skills: ${player.skills.values.join(", ")}'),
                    );
                  },
                ),
                const Divider(),
                // Display the average skill of the team
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
      teams = _swapRandomPlayers(teams);
    });
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
}
