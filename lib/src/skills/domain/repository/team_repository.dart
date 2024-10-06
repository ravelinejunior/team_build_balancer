import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/skills/domain/model/player_model.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/domain/model/teams_model.dart';

abstract class TeamRepository {
  ResultFuture<void> addPlayer(PlayerModel player);
  ResultFuture<void> addSkill(SkillModel skill);
  ResultFuture<void> addSkillToPlayer(int playerId, SkillModel skillModel);

  ResultFuture<List<PlayerModel>> getPlayers();
  ResultFuture<List<SkillModel>> getSkills();
  ResultFuture<List<TeamsModel>> generateTeams(int numTeams);

  ResultFuture<void> deletePlayer(PlayerModel player);
  ResultFuture<void> deleteSkill(SkillModel skill);

  ResultFuture<void> updatePlayer(PlayerModel player);
  ResultFuture<void> updateSkill(SkillModel skill);
}
