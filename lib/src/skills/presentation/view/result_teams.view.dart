import 'package:flutter/material.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
import 'package:team_build_balancer/src/skills/presentation/view/controller/result_teams_controller.dart';
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
  late ResultTeamsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ResultTeamsController(initialTeams: widget.initialTeams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teams Result"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_rounded),
            onPressed: () async{
              await _showExportDialog(_controller.teams);
            },
            tooltip: 'Export Teams',
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView.builder(
        itemCount: _controller.teams.length,
        itemBuilder: (context, teamIndex) {
          final team = _controller.teams[teamIndex];
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
                    "Average Skill: ${_controller.calculateTeamAverage(team).toStringAsFixed(2)}",
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

  void _reshuffleTeams() {
    setState(() {
      List<List<NewPlayer>> shuffledTeams = _controller.balanceTeams();
      if (_controller.areTeamsEqual(_controller.teams, shuffledTeams)) {
        CoreUtils.showSnackBar(context, 'Teams are already balanced!');
      } else {
        _controller.teams = shuffledTeams;
      }
    });
  }


  // Display confirmation dialog before exporting
  Future _showExportDialog(
    List<List<NewPlayer>> teams
  ) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Export'),
          content: const Text('Do you want to export the current teams?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                _exportTeams(teams);
                Navigator.of(context).pop();
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  // Call export function from controller
  Future<void> _exportTeams(List<List<NewPlayer>> teams) async{
    await _controller.exportTeamsAsCSV(teams);
    await _controller.exportTeamsAsJSON(teams);
    // ignore: use_build_context_synchronously
    CoreUtils.showSnackBar(context, 'Teams exported successfully!');
  }
}
