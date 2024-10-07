class NewPlayer {
  final String name;
  final Map<String, int> skills;

  NewPlayer({required this.name, required this.skills});

  // Optional: Calculate the total skill score if needed
  int get totalSkillValue => skills.values.reduce((a, b) => a + b);

  static List<List<NewPlayer>> generateTeams(
      List<NewPlayer> players, int numTeams) {
    // Sort players by their total skill value in descending order
    players.sort((a, b) => b.totalSkillValue.compareTo(a.totalSkillValue));

    // Initialize empty lists for the teams
    List<List<NewPlayer>> teams = List.generate(numTeams, (_) => []);

    // Distribute players across the teams
    for (int i = 0; i < players.length; i++) {
      // Add the player to the team, rotating between teams to balance skill levels
      teams[i % numTeams].add(players[i]);
    }

    return teams;
  }

// Function to calculate the average skill score for each team
  static double calculateTeamAverage(List<NewPlayer> team) {
    int totalSkillValue = 0;
    int totalSkills = 0;

    for (var player in team) {
      totalSkillValue += player.totalSkillValue;
      totalSkills += player.skills.length;
    }

    return totalSkills > 0 ? totalSkillValue / totalSkills : 0.0;
  }

  @override
  String toString() {
    return 'Player: $name, Skills: $skills';
  }
}
