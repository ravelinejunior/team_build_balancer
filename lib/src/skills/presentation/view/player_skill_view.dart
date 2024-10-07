import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
import 'package:team_build_balancer/src/skills/domain/model/new_player.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
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

  // Mocked list of skills
  final List<String> skills = ["ATK", "DF", "SKILL"];

  final String skillTip =
      "The skill is based on what you judge important for the player (good server, good spike, good shot)";

  // Mocked list of score options
  final List<int> scoreOptions = List<int>.generate(10, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
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
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 80.0), // Adds padding for the FAB
            child: ListView.builder(
              itemCount: widget.params.amountOfPlayers,
              itemBuilder: (context, index) {
                return Column(
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
                      // Validator to ensure the name is entered
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
                              child: Tooltip(
                                message: (skills[i] == "SKILL") ? skillTip : '',
                                textStyle: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: DropdownButtonFormField<int>(
                                  value: int.tryParse(
                                      playerSkillsControllers[index][i].text),
                                  decoration: InputDecoration(
                                    labelText: skills[i],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
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
                                    if (value == null) {
                                      return 'Select ${skills[i]} score';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Only display divider if it's not the last item
                    if (index != widget.params.amountOfPlayers - 1)
                      const Divider(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      extendBody: true,
      // Add padding for the FAB
      // Submit Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSubmit,
        label: const Text("Generate Teams"),
        icon: const Icon(Icons.group),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, now dispatch the skills and player names to the BLoC
      List<NewPlayer> players = [];

      // Loop through the number of players and store their names and skills
      for (int i = 0; i < widget.params.amountOfPlayers; i++) {
        String playerName = playerNameControllers[i].text;
        Map<String, int> playerSkills = {};

        // Loop through each skill and assign its value
        for (int j = 0; j < skills.length; j++) {
          playerSkills[skills[j]] =
              int.tryParse(playerSkillsControllers[i][j].text) ?? 0;
          debugPrint(
              "Player ${i + 1} ${skills[j]}: ${playerSkills[skills[j]]}");
        }

        // Add the player model to the list
        players.add(NewPlayer(name: playerName, skills: playerSkills));
      }

      // Generate balanced teams
      List<List<NewPlayer>> teams =
          NewPlayer.generateTeams(players, widget.params.amountOfTeams);

      // Print the teams or use them for further logic
      for (int i = 0; i < teams.length; i++) {
        debugPrint('Team ${i + 1}:');
        for (var player in teams[i]) {
          debugPrint(player.toString());
        }
      }

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
              onPressed: () => _importFromClipboard(),
              child: const Text("Paste from Clipboard"),
            ),
          ],
        );
      },
    );
  }

  Future _importFromClipboard() async {
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
      setState(() {
        for (int i = 0;
            i < importedNames.length && i < playerNameControllers.length;
            i++) {
          playerNameControllers[i].text = importedNames[i];
        }
      });

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Close dialog
    }
  }
}
