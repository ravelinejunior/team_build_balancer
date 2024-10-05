part of 'sports_bloc.dart';

sealed class SportsState extends Equatable {
  const SportsState();

  @override
  List<Object> get props => [];
}

final class SportsInitial extends SportsState {
  const SportsInitial();

  @override
  List<Object> get props => [];
}

final class SportsLoading extends SportsState {
  const SportsLoading();

  @override
  List<Object> get props => [];
}

final class SportsListLoaded extends SportsState {
  final List<SportsModel> sports;

  const SportsListLoaded(this.sports);

  @override
  List<Object> get props => [sports];
}

final class SportSelectedByIdLoaded extends SportsState {
  final SportsModel selectedSport;

  const SportSelectedByIdLoaded(this.selectedSport);

  @override
  List<Object> get props => [selectedSport];
}

final class SportsError extends SportsState {
  final String message;

  const SportsError(this.message);

  @override
  List<Object> get props => [message];
}
