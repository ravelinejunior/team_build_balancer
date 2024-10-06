import 'package:team_build_balancer/core/use_case/use_case.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/skills/domain/model/player_model.dart';
import 'package:team_build_balancer/src/skills/domain/repository/team_repository.dart';

class GetPlayersUseCase extends UseCaseWithoutParams<List<PlayerModel>> {
  final TeamRepository _teamRepository;
  GetPlayersUseCase(this._teamRepository);
  

  @override
  ResultFuture<List<PlayerModel>> call() {
    return _teamRepository.getPlayers();
  }
}
