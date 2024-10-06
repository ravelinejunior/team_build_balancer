import 'package:dartz/dartz.dart';
import 'package:team_build_balancer/core/extensions/failures_extensions.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/skills/data/data_source/data_source.dart';
import 'package:team_build_balancer/src/skills/domain/model/teams_model.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/domain/model/player_model.dart';
import 'package:team_build_balancer/src/skills/domain/repository/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  TeamRepositoryImpl(this._teamsDataSource);
  final TeamsDataSource _teamsDataSource;

  @override
  ResultFuture<void> addPlayer(PlayerModel player) async {
    try {
      _teamsDataSource.addPlayer(player);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<void> addSkill(SkillModel skill) async {
    try {
      _teamsDataSource.addSkill(skill);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<void> addSkillToPlayer(
    int playerId,
    SkillModel skillModel,
  ) async {
    try {
      _teamsDataSource.addSkillToPlayer(playerId, skillModel);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<void> deletePlayer(PlayerModel player) async {
    try {
      _teamsDataSource.deletePlayer(player);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<void> deleteSkill(SkillModel skill) async {
    try {
      _teamsDataSource.deleteSkill(skill);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<List<TeamsModel>> generateTeams(int numTeams) async {
    try {
      final teams = await _teamsDataSource.generateTeams(numTeams);
      if (teams.isNotEmpty) {
        return Right(teams);
      } else {
        return const Left(
          ServerFailure(
            message: 'Teams not generated',
            statusCode: 505,
          ),
        );
      }
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<List<PlayerModel>> getPlayers() async {
    try {
      final players = await _teamsDataSource.getPlayers();
      if (players.isNotEmpty) {
        return Right(players);
      } else {
        return const Left(
          ServerFailure(
            message: 'Players not found',
            statusCode: 505,
          ),
        );
      }
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<List<SkillModel>> getSkills() async {
    try {
      final skills = await _teamsDataSource.getSkills();
      if (skills.isNotEmpty) {
        return Right(skills);
      } else {
        return const Left(
          ServerFailure(
            message: 'Skills not found',
            statusCode: 505,
          ),
        );
      }
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<void> updatePlayer(PlayerModel player) async {
    try {
      _teamsDataSource.updatePlayer(player);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }

  @override
  ResultFuture<void> updateSkill(SkillModel skill) async {
    try {
      _teamsDataSource.updateSkill(skill);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 505,
        ),
      );
    }
  }
}
