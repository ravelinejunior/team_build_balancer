import 'package:flutter/material.dart';
import 'package:team_build_balancer/core/dependency_injection/injection_container.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
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

  final String skillTip =
      "The skill is based on what you judge important for the player (good server, good spike, good shot)";

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
        title: const Text("Players and Skills"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Import Players',
            onPressed: () => _showImportDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Export Players',
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
                        label: const Text("Add New Player"),
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
                          context, index);
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
                            labelText: "Player ${index + 1} Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter player name';
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
                                        return 'Select ${skills[i]} score';
                                      }
                                      if (value == null) {
                                        return 'Select ${skills[i]} score';
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
        label: const Text("Generate Teams"),
        icon: const Icon(Icons.group),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, int index) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete Player ${index + 1}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
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
      CoreUtils.showSnackBar(context, 'Please fill in all fields correctly');
    }
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Import Players from WhatsApp"),
          content: const Text("Paste the names below (one per line):"),
          actions: [
            TextButton(
              onPressed: () => _playerSkillController.importFromClipboard(
                playerNameControllers: playerNameControllers,
                context: context,
              ),
              child: const Text("Paste from Clipboard"),
            ),
          ],
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

  _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Players"),
          content: const Text("Are you sure you want to delete all players?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red.shade400),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                _playerSkillController.clearPlayerData(
                  playerNameControllers: playerNameControllers,
                  playerSkillsControllers: playerSkillsControllers,
                  sportName: widget.params.sportName,
                );
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
