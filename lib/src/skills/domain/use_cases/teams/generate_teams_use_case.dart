import 'package:team_build_balancer/core/use_case/use_case.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/skills/domain/model/teams_model.dart';
import 'package:team_build_balancer/src/skills/domain/repository/team_repository.dart';

class GenerateTeamsUseCase extends UseCaseWithParams<List<TeamsModel>, int> {
  GenerateTeamsUseCase(this._teamRepository);
  final TeamRepository _teamRepository;

  @override
  ResultFuture<List<TeamsModel>> call(int params) {
    return _teamRepository.generateTeams(params);
  }
}
