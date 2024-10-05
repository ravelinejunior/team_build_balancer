import 'package:dartz/dartz.dart';
import 'package:team_build_balancer/core/extensions/failures_extensions.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
