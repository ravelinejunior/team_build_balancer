import 'package:team_build_balancer/core/use_case/use_case.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/domain/repository/team_repository.dart';

class UpdateSkillUseCase extends UseCaseWithParams<void, SkillModel> {
  UpdateSkillUseCase(this._teamRepository);

  final TeamRepository _teamRepository;

  @override
  ResultFuture<void> call(SkillModel params) {
   return  _teamRepository.updateSkill(params);
  }
}
