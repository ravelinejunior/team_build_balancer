import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_build_balancer/core/dependency_injection/injection_container.dart';
import 'package:team_build_balancer/core/localization/l10n.dart';
import 'package:team_build_balancer/core/utils/contants.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/presentation/view/player_skill_view.dart';
import 'package:team_build_balancer/src/sports/domain/model/sports.dart';

class SkillInputView extends StatefulWidget {
  const SkillInputView({Key? key, required this.sport}) : super(key: key);
  final SportsModel sport;

  @override
  State<SkillInputView> createState() => _SkillInputViewState();
}

class _SkillInputViewState extends State<SkillInputView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController playersController = TextEditingController();
  final TextEditingController teamsController = TextEditingController();

  final sharedPrefs = serviceLocator<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPrefs();
  }

  void _loadDataFromSharedPrefs() {
    final data = sharedPrefs
        .getString(getSharedKeyBySportForSkillScreen(widget.sport.name));
    if (data != null) {
      final params = SkillToPlayerAmountParams.fromMap(jsonDecode(data));
      _initSkillByTeam(params: params);
    }
  }

  void _initSkillByTeam({required SkillToPlayerAmountParams params}) {
    playersController.text = params.amountOfPlayers.toString();
    teamsController.text = params.amountOfTeams.toString();
  }

  @override
  void dispose() {
    playersController.dispose();
    teamsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sport.name),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular image representing the selected sport
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    widget.sport.image ?? '',
                  ),
                ),
                const SizedBox(height: 20),
                // Number of Players Input
                TextFormField(
                  controller: playersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                        ?.translate('numberOfPlayersText'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    prefixIcon:
                        const Icon(Icons.people), // Icon for number of players
                  ),
                  // Validator to check if the input is a positive number
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                          ?.translate('positiveNumberOfPlayersText');
                    }
                    final numPlayers = int.tryParse(value);
                    if (numPlayers == null || numPlayers <= 0) {
                      return AppLocalizations.of(context)
                          ?.translate('validNumberOfPlayersOrTeamsText');
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}')),
                  ],
                ),
                const SizedBox(height: 20),
                // Number of Teams Input
                TextFormField(
                  controller: teamsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                        ?.translate('numberOfTeamsText'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    prefixIcon:
                        const Icon(Icons.group), // Icon for number of teams
                  ),
                  // Validator to check if the input is a positive number
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                          ?.translate('positiveNumberOfTeamsText');
                    }
                    final numTeams = int.tryParse(value);
                    if (numTeams == null || numTeams <= 0) {
                      return AppLocalizations.of(context)
                          ?.translate('validNumberOfPlayersOrTeamsText');
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}')),
                  ],
                ),
                const SizedBox(height: 20),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      minimumSize: const Size.fromHeight(40),
                    ),
                    onPressed: () {
                      _onSubmit(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('nextText'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, we dispatch the necessary events to the BLoC

      final players = int.tryParse(playersController.text) ?? 0;
      final teams = int.tryParse(teamsController.text) ?? 0;
      final params = SkillToPlayerAmountParams(
        amountOfPlayers: players,
        amountOfTeams: teams,
        sportName: widget.sport.name,
      );
      final sportData = params.toJson();
      debugPrint(sportData);

      // Save the parameters in shared preferences
      sharedPrefs.setString(
        getSharedKeyBySportForSkillScreen(widget.sport.name),
        sportData,
      );

      // Navigate to the next screen (e.g., PlayersSkillsView) based on success
      Navigator.pushNamed(
        context,
        PlayersSkillsView.routeName,
        arguments: params,
      );
    } else {
      // Show error or validation feedback
      CoreUtils.showSnackBar(
        context,
        AppLocalizations.of(context)!.translate('verifyFieldsErrorMessage'),
      );
    }
  }
}
