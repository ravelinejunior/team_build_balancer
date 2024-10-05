import 'package:team_build_balancer/core/use_case/use_case.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/sports/domain/model/sports.dart';
import 'package:team_build_balancer/src/sports/domain/repository/sports_repository.dart';

class GetSportsUseCase extends UseCaseWithoutParams<List<SportsModel>> {
  GetSportsUseCase(this._sportsRepository);
  final SportsRepository _sportsRepository;
  @override
  ResultFuture<List<SportsModel>> call() => _sportsRepository.getSports();
}
