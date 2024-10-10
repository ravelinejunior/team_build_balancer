import 'package:flutter/material.dart';
import 'package:team_build_balancer/core/localization/l10n.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
import 'package:team_build_balancer/core/widgets/custom_alert_dialog.dart';
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
        title: Text(
          AppLocalizations.of(context)?.translate('exportTeamsText') ??
              "Teams Result",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_rounded),
            onPressed: () async {
              await _showExportDialog(_controller.teams);
            },
            tooltip:
                AppLocalizations.of(context)?.translate('exportTeamsText') ??
                    'Export Teams',
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
                  '${AppLocalizations.of(context)?.translate('teamIndexIndicationText')} '
                  '${teamIndex + 1}',
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
                        child: Text(player.name[0]),
                      ),
                      title: Text(player.name),
                      subtitle: Text(
                        '${AppLocalizations.of(context)?.translate('totalSkillValueText')}: '
                        '${player.totalSkillValue}',
                      ),
                    );
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${AppLocalizations.of(context)?.translate('averageSkillValueText')}: '
                    '${_controller.calculateTeamAverage(team).toStringAsFixed(2)}',
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
        tooltip: AppLocalizations.of(context)?.translate('reshufleTeamsText') ??
            'Reshuffle Teams',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _reshuffleTeams() {
    setState(() {
      List<List<NewPlayer>> shuffledTeams = _controller.balanceTeams();
      if (_controller.areTeamsEqual(_controller.teams, shuffledTeams)) {
        CoreUtils.showSnackBar(
            context,
            AppLocalizations.of(context)
                    ?.translate('teamsAlreadyBalancedMessage') ??
                'Teams are already balanced!');
      } else {
        _controller.teams = shuffledTeams;
      }
    });
  }

  // Display confirmation dialog before exporting
  Future _showExportDialog(List<List<NewPlayer>> teams) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: AppLocalizations.of(context)?.translate('confirmExportText') ??
              'Confirm Export',
          content: AppLocalizations.of(context)?.translate('confirmExportMessage') ??
              'Do you want to export the current teams?',
          positiveButtonText:
              AppLocalizations.of(context)?.translate('exportText') ??
                  'Export',
          negativeButtonText:
              AppLocalizations.of(context)?.translate('cancelText') ??
                  'Cancel',
          onPositivePressed: () async {
            _exportTeams(teams);
            Navigator.of(context).pop();
          },
          onNegativePressed: () => Navigator.of(context).pop(),
        );

        /* return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.translate('confirmExportText') ??
                'Confirm Export',
          ),
          content: Text(
            AppLocalizations.of(context)?.translate('confirmExportMessage') ??
                'Do you want to export the current teams?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                  AppLocalizations.of(context)?.translate('cancelText') ??
                      'Cancel'),
            ),
            TextButton(
              onPressed: () async {
                _exportTeams(teams);
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)?.translate('exportText') ??
                    'Export',
              ),
            ),
          ],
        ); */
      },
    );
  }

  // Call export function from controller
  Future<void> _exportTeams(List<List<NewPlayer>> teams) async {
    await _controller.exportTeamsAsCSV(teams);
    await _controller.exportTeamsAsJson(teams);
    await _controller.shareTeamsToWhatsApp(teams);
    // ignore: use_build_context_synchronously
    CoreUtils.showSnackBar(
      context,
      AppLocalizations.of(context)
              ?.translate('exportedTeamsSuccessfullyMessage') ??
          '',
    );
  }
}
