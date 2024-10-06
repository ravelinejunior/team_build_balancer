import 'package:team_build_balancer/src/skills/domain/model/player_model.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/domain/model/teams_model.dart';

abstract class TeamsDataSource {
  Future<List<TeamsModel>> generateTeams(int numTeams);

  Future<List<SkillModel>> getSkills();
  Future<void> addSkill(SkillModel skill);
  Future<void> addSkillToPlayer(int playerId, SkillModel skillModel);
  Future<void> deleteSkill(SkillModel skill);
  Future<void> updateSkill(SkillModel skill);

  Future<List<PlayerModel>> getPlayers();
  Future<void> addPlayer(PlayerModel player);
  Future<void> deletePlayer(PlayerModel player);
  Future<void> updatePlayer(PlayerModel player);
}

class TeamsDataSourceImpl implements TeamsDataSource {
  final List<PlayerModel> _players = [];
  final List<SkillModel> _skills = [];
  @override
  Future<void> addPlayer(PlayerModel player) async {
    _players.add(player);
  }

  @override
  Future<void> addSkill(SkillModel skill) async {
    _skills.add(skill);
  }

  @override
  Future<void> addSkillToPlayer(int playerId, SkillModel skillModel) async {
    final player = _players.firstWhere((p) => p.id == playerId);
    player.skills.add(skillModel);
  }

  @override
  Future<void> deletePlayer(PlayerModel player) async {
    _players.remove(player);
  }

  @override
  Future<void> deleteSkill(SkillModel skill) async {
    _skills.remove(skill);
  }

  @override
  Future<List<TeamsModel>> generateTeams(int numTeams) async {
    // Sort players by total skill value
    _players.sort((a, b) {
      int skillA = a.skills.fold(0, (sum, skill) => sum + skill.value);
      int skillB = b.skills.fold(0, (sum, skill) => sum + skill.value);
      return skillB.compareTo(skillA); // Descending order
    });

    // Initialize teams
    List<TeamsModel> teams = List.generate(
      numTeams,
      (i) => TeamsModel(
        id: i,
        name: 'Team ${i + 1}',
        players: _players,
      ),
    );

    // Distribute players across teams
    for (int i = 0; i < _players.length; i++) {
      teams[i % numTeams].players.add(_players[i]);
    }

    return teams;
  }

  @override
  Future<List<PlayerModel>> getPlayers() async {
    return _players;
  }

  @override
  Future<List<SkillModel>> getSkills() async {
    return _skills;
  }

  @override
  Future<void> updatePlayer(PlayerModel player) async {
    _players.map(
      (e) {
        if(e.id == player.id){
          e = player;
        }
      },
    );
  }

  @override
  Future<void> updateSkill(SkillModel skill) async {
    _skills.map(
      (e) {
        if(e.id == skill.id){
          e = skill;
        }
      },
    );
  }
}
