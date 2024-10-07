part of 'teams_bloc.dart';

sealed class TeamsEvent extends Equatable {
  const TeamsEvent();
}

// Player Events
class AddPlayerEvent extends TeamsEvent {
  final PlayerModel player;
  const AddPlayerEvent(this.player);

  @override
  List<Object?> get props => [player];
}

class UpdatePlayerEvent extends TeamsEvent {
  final PlayerModel player;
  const UpdatePlayerEvent(this.player);

  @override
  List<Object?> get props => [player];
}

class DeletePlayerEvent extends TeamsEvent {
  final PlayerModel player;
  const DeletePlayerEvent(this.player);

  @override
  List<Object?> get props => [player];
}

class FetchPlayersEvent extends TeamsEvent {
  @override
  List<Object?> get props => [];
}

// Skill Events
class AddSkillEvent extends TeamsEvent {
  final SkillModel skill;
  const AddSkillEvent(this.skill);

  @override
  List<Object?> get props => [skill];
}

class UpdateSkillEvent extends TeamsEvent {
  final SkillModel skill;
  const UpdateSkillEvent(this.skill);

  @override
  List<Object?> get props => [skill];
}

class DeleteSkillEvent extends TeamsEvent {
  final SkillModel skill;
  const DeleteSkillEvent(this.skill);

  @override
  List<Object?> get props => [skill];
}

class AssignSkillToPlayerEvent extends TeamsEvent {
  final int playerId;
  final SkillModel skill;
  const AssignSkillToPlayerEvent(this.playerId, this.skill);

  @override
  List<Object?> get props => [playerId, skill];
}

class FetchSkillsEvent extends TeamsEvent {
  @override
  List<Object?> get props => [];
}

// Team Generation Events
class GenerateTeamsEvent extends TeamsEvent {
  final int numTeams;
  const GenerateTeamsEvent(this.numTeams);

  @override
  List<Object?> get props => [numTeams];
}
