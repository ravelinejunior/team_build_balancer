import 'package:team_build_balancer/core/use_case/use_case.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/skills/domain/model/player_model.dart';
import 'package:team_build_balancer/src/skills/domain/repository/team_repository.dart';

class UpdatePlayerUseCase extends UseCaseWithParams<void, PlayerModel> {
  UpdatePlayerUseCase(this._teamRepository);

  final TeamRepository _teamRepository;

  @override
  ResultFuture<void> call(PlayerModel params) {
   return  _teamRepository.updatePlayer(params);
  }
}
