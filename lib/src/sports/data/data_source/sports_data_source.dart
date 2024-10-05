import 'package:team_build_balancer/src/sports/domain/model/sports.dart';

abstract class SportsDataSource {
  Future<List<SportsModel>> getSports();
  Future<SportsModel> getSportById(int id);
}

class SportsDataSourceImpl implements SportsDataSource {
  @override
  Future<List<SportsModel>> getSports() async {
    return await Future.delayed(
      const Duration(seconds: 3),
      () {
        return SportsModel.mockDefaultSports();
      },
    );
  }

  @override
  Future<SportsModel> getSportById(int id) async {
    return await Future.delayed(
      const Duration(seconds: 3),
      () {
        return SportsModel.mockDefaultSports().firstWhere(
          (element) => element.id == id,
          orElse: () => SportsModel.mockDefaultSports().first,
        );
      },
    );
  }
}
