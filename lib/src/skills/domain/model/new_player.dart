class NewPlayer {
  final String name;
  final Map<String, int> skills; // Map of skills to their values
  double totalSkillValue = 0.0;

  NewPlayer({required this.name, required this.skills})
      : totalSkillValue = skills.values.reduce((a, b) => a + b).toDouble();
}
