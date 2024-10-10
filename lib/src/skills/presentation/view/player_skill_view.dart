import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_build_balancer/core/dependency_injection/injection_container.dart';
import 'package:team_build_balancer/core/localization/l10n.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
import 'package:team_build_balancer/core/widgets/custom_alert_dialog.dart';
import 'package:team_build_balancer/src/skills/domain/model/new_player.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/presentation/view/controller/player_skill_controller.dart';
import 'package:team_build_balancer/src/skills/presentation/view/result_teams.view.dart';

class PlayersSkillsView extends StatefulWidget {
  const PlayersSkillsView({required this.params, Key? key}) : super(key: key);
  final SkillToPlayerAmountParams params;
  static const String routeName = '/players';

  @override
  State<PlayersSkillsView> createState() => _PlayersSkillsViewState();
}

class _PlayersSkillsViewState extends State<PlayersSkillsView> {
  final _formKey = GlobalKey<FormState>();

  // List of TextEditingControllers for player names and skill values
  List<TextEditingController> playerNameControllers = [];
  List<List<TextEditingController>> playerSkillsControllers = [];

  // Instantiate PlayerSkillController
  late PlayerSkillController _playerSkillController;

  // Mocked list of skills
  final List<String> skills = ["ATK", "DF", "SKILL"];

  // Mocked list of score options
  final List<int> scoreOptions = List<int>.generate(10, (index) => index + 1);

  // Define skill weights
  final Map<String, double> skillWeights = {
    'ATK': 1.0,
    'DF': 1.0,
    'SKILL': 1.0,
  };

  @override
  void initState() {
    super.initState();
    _playerSkillController = serviceLocator<PlayerSkillController>();
    _initializeControllers();
    _loadSavedData(); // Load saved player data if available
  }

  void _loadSavedData() {
    // Use the controller to load saved player data
    _playerSkillController.loadPlayerData(
      playerNameControllers: playerNameControllers,
      playerSkillsControllers: playerSkillsControllers,
      skills: skills,
      sportName: widget.params.sportName,
    );
  }

  void _savePlayerData() {
    // Use the controller to save current player data
    _playerSkillController.savePlayerData(
      playerNameControllers: playerNameControllers,
      playerSkillsControllers: playerSkillsControllers,
      skills: skills,
      amountOfPlayers: playerNameControllers.length,
      sportName: widget.params.sportName,
    );
  }

  void _initializeControllers() {
    // Initialize controllers for each player and their respective skills
    for (int i = 0; i < widget.params.amountOfPlayers; i++) {
      playerNameControllers.add(TextEditingController());

      List<TextEditingController> skillControllers = [];
      for (int j = 0; j < skills.length; j++) {
        skillControllers.add(TextEditingController());
      }
      playerSkillsControllers.add(skillControllers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.translate('playerSkillAppBarTitle') ??
              '',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip:
                AppLocalizations.of(context)?.translate('importPlayersText') ??
                    '',
            onPressed: () => _showImportDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip:
                AppLocalizations.of(context)?.translate('deletePlayersText') ??
                    '',
            onPressed: () => _showDeleteDialog(),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: ListView.builder(
              itemCount: playerNameControllers.length +
                  1, // Add 1 to include the 'Add Player' button
              itemBuilder: (context, index) {
                if (index == playerNameControllers.length) {
                  // Last item, showing the button to add a new player
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          _playerSkillController.addNewPlayer(
                            playerNameControllers: playerNameControllers,
                            playerSkillsControllers: playerSkillsControllers,
                            skills: skills,
                          );
                          setState(
                            () {},
                          ); // Rebuild the widget to show the new player
                        },
                        icon: const Icon(Icons.add),
                        label: Text(
                          AppLocalizations.of(context)
                                  ?.translate('addPlayerText') ??
                              '',
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                } else {
                  // Regular player input (the same as before)
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      // Show confirmation dialog
                      return await _showDeleteConfirmationDialog(
                        context,
                        index,
                      );
                    },
                    onDismissed: (direction) {
                      _playerSkillController.deletePlayer(
                        index: index,
                        playerNameControllers: playerNameControllers,
                        playerSkillsControllers: playerSkillsControllers,
                      );
                      setState(() {});
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Player Name Input
                        TextFormField(
                          controller: playerNameControllers[index],
                          decoration: InputDecoration(
                            labelText:
                                "${AppLocalizations.of(context)?.translate('validPlayerNameText')} ${index + 1}",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                  ?.translate('validPlayerNameText');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Skill inputs for each player
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < skills.length; i++) ...[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: DropdownButtonFormField<int>(
                                    value: int.tryParse(
                                        playerSkillsControllers[index][i].text),
                                    decoration: InputDecoration(
                                      labelText: skills[i],
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                    ),
                                    items: scoreOptions
                                        .map<DropdownMenuItem<int>>(
                                          (int value) => DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(value.toString()),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        playerSkillsControllers[index][i].text =
                                            newValue.toString();
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return '${AppLocalizations.of(context)?.translate('validScoreSkillText')} ${skills[i]}';
                                      }
                                      if (value == null) {
                                        return '${AppLocalizations.of(context)?.translate('validScoreSkillText')} ${skills[i]}';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (index != playerNameControllers.length - 1)
                          const Divider(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSubmit,
        label: Text(
          AppLocalizations.of(context)?.translate('generateTeamsTitle') ?? '',
        ),
        icon: const Icon(Icons.group),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, int index) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.translate('confirmDeletionTitle') ??
                '',
          ),
          content: Text(
            '${AppLocalizations.of(context)?.translate('confirmDeletionTitle')} ${index + 1}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                AppLocalizations.of(context)?.translate('cancelText') ?? '',
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                AppLocalizations.of(context)?.translate('deleteText') ?? '',
              ),
            ),
          ],
        );
      },
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate() &&
        _playerSkillController.verifyIfAllTextEditingAreFilled(
            playerNameControllers, playerSkillsControllers)) {
      // Form is valid, now dispatch the skills and player names to the BLoC
      List<NewPlayer> players = [];

      // Loop through the number of players and store their names and skills
      for (int i = 0; i < playerNameControllers.length; i++) {
        String playerName = playerNameControllers[i].text;
        Map<String, int> playerSkills = {};

        // Loop through each skill and assign its value
        for (int j = 0; j < skills.length; j++) {
          playerSkills[skills[j]] =
              int.tryParse(playerSkillsControllers[i][j].text) ?? 0;
        }

        // Add the player model to the list
        players.add(
          NewPlayer(
            name: playerName,
            skills: playerSkills,
          ),
        );
      }

      _savePlayerData();

      // Generate balanced teams
      List<List<NewPlayer>> teams = _playerSkillController.generateTeams(
        players: players,
        numTeams: widget.params.amountOfTeams,
        skillWeights: skillWeights,
      );

      // Navigate or show a success message
      Navigator.pushNamed(context, ResultTeamsView.routeName, arguments: teams);
    } else {
      // Show error message if validation fails
      CoreUtils.showSnackBar(
        context,
        AppLocalizations.of(context)?.translate('verifyFieldsErrorMessage') ??
            '',
      );
    }
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)
                    ?.translate('importPlayersWhatsAppTitle') ??
                '',
            textAlign: TextAlign.center,
          ),
          content: Text(
            AppLocalizations.of(context)
                    ?.translate('pasteImportPlayersMessage') ??
                '',
          ),
          actions: [
            TextButton(
              onPressed: () => _playerSkillController.importFromClipboard(
                playerNameControllers: playerNameControllers,
                context: context,
              ),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                elevation: 12,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)
                          ?.translate('pastePlayersFromClipboard') ??
                      '',
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: AppLocalizations.of(context)!.translate('deletePlayersText'),
          content: AppLocalizations.of(context)!
              .translate('deleteAllPlayersMessage'),
          positiveButtonText:
              AppLocalizations.of(context)!.translate('confirmText'),
          negativeButtonText:
              AppLocalizations.of(context)!.translate('cancelText'),
          onPositivePressed: () {
            _playerSkillController.clearPlayerData(
              playerNameControllers: playerNameControllers,
              playerSkillsControllers: playerSkillsControllers,
              sportName: widget.params.sportName,
            );
            Navigator.of(context).pop();
            setState(() {});
          },
          onNegativePressed: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    for (var controller in playerNameControllers) {
      controller.dispose();
    }
    for (var skillsList in playerSkillsControllers) {
      for (var skillController in skillsList) {
        skillController.dispose();
      }
    }
    super.dispose();
  }
}
