part of 'sports_bloc.dart';

sealed class SportsEvent extends Equatable {
  const SportsEvent();
}

class GetSportsEvent extends SportsEvent {
  @override
  List<Object> get props => [];
}

class GetSportByIdEvent extends SportsEvent {
  final int id;

  const GetSportByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}
