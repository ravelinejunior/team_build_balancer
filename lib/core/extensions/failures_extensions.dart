import 'package:equatable/equatable.dart';
import 'package:team_build_balancer/core/extensions/exceptions_extensions.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final int statusCode;

  String get errorMessage => '$message - $statusCode';

  @override
  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required super.statusCode,
  });

  ServerFailure.fromException(ServerException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    required super.statusCode,
  });
}
