import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:team_build_balancer/core/extensions/failures_extensions.dart';
import 'package:team_build_balancer/src/sports/data/data_source/sports_data_source.dart';
import 'package:team_build_balancer/src/sports/domain/model/sports.dart';
import 'package:team_build_balancer/core/utils/typedef.dart';
import 'package:team_build_balancer/src/sports/domain/repository/sports_repository.dart';

class SportsRepositoryImpl implements SportsRepository {
  const SportsRepositoryImpl(this._sportsDataSource);
  final SportsDataSource _sportsDataSource;
  @override
  ResultFuture<SportsModel> getSportById(int id) async {
    try {
      final selectedSport = await _sportsDataSource.getSportById(id);
      return Right(selectedSport);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<List<SportsModel>> getSports() async {
    try {
      final sports = await _sportsDataSource.getSports();
      for (SportsModel item in sports) {
        debugPrint(
          item.toJson(),
        );
      }
      return Right(sports);
    } catch (e) {
      return Left(
        ServerFailure(
          message: e.toString(),
          statusCode: 500,
        ),
      );
    }
  }
}
