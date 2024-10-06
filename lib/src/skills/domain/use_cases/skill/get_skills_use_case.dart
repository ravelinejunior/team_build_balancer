import 'package:team_build_balancer/core/use_case/use_case.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/domain/repository/team_repository.dart';

class GetSkillsUseCase extends UseCaseWithoutParams<List<SkillModel>> {
  final TeamRepository _teamRepository;
  GetSkillsUseCase(this._teamRepository);
  
  @override
  ResultFuture<List<SkillModel>> call() {
    return _teamRepository.getSkills();
  }
}
