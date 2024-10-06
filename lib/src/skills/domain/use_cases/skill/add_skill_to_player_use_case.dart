import 'package:team_build_balancer/core/use_case/use_case.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/domain/repository/team_repository.dart';

class AddSkillToPlayerUseCase extends UseCaseWithParams<void, SkillToPlayerParams> {
  AddSkillToPlayerUseCase(this._teamRepository);

  final TeamRepository _teamRepository;

  @override
  ResultFuture<void> call(SkillToPlayerParams params) {
    return _teamRepository.addSkillToPlayer(
      params.playerId,
      params.skillModel
    );
  }
}

class SkillToPlayerParams{
  final int playerId;
  final SkillModel skillModel;
  SkillToPlayerParams(this.playerId, this.skillModel);
}
