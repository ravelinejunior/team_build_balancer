import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/sports/domain/model/sports.dart';

abstract class SportsRepository{
  ResultFuture<List<SportsModel>> getSports();

  ResultFuture<SportsModel> getSportById(int id);
}