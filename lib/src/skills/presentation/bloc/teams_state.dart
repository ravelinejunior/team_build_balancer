part of 'teams_bloc.dart';

sealed class TeamsState extends Equatable {
  const TeamsState();

  @override
  List<Object> get props => [];
}

final class TeamsInitial extends TeamsState {
  const TeamsInitial();
}

final class TeamsStateLoading extends TeamsState {
  const TeamsStateLoading();

  @override
  List<Object> get props => [];
}

final class TeamsStateLoaded extends TeamsState {
  final List<TeamsModel> teams;

  const TeamsStateLoaded({required this.teams});

  @override
  List<Object> get props => [teams];
}

final class PlayerAddedState extends TeamsState {

  const PlayerAddedState();

  @override
  List<Object> get props => [];
}

final class PlayersAddedState extends TeamsState {
  final List<PlayerModel> players;

  const PlayersAddedState({required this.players});

  @override
  List<Object> get props => [players];
}

class SkillAddedState extends TeamsState {

  const SkillAddedState();

  @override
  List<Object> get props => [];
}

class SkillsAddedState extends TeamsState {
  final List<SkillModel> skills;

  const SkillsAddedState({required this.skills});

  @override
  List<Object> get props => [skills];
}

class AddedSkillToPlayerState extends TeamsState{

  const AddedSkillToPlayerState();

  @override
  List<Object> get props => [];
}

class SkillDeletedState extends TeamsState{

  const SkillDeletedState();

  @override
  List<Object> get props => [];
}

class PlayerDeletedState extends TeamsState{

  const PlayerDeletedState();

  @override
  List<Object> get props => [];
}

class SkillUpdatedState extends TeamsState{

  const SkillUpdatedState();

  @override
  List<Object> get props => [];
}

class PlayerUpdatedState extends TeamsState{

  const PlayerUpdatedState();

  @override
  List<Object> get props => [];
}

final class TeamsStateError extends TeamsState {
  final String message;

  const TeamsStateError({required this.message});

  @override
  List<Object> get props => [message];
}
