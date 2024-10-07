import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:team_build_balancer/src/skills/domain/model/player_model.dart';
import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';
import 'package:team_build_balancer/src/skills/domain/model/teams_model.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/player/add_player_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/player/delete_player_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/player/get_players_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/player/update_player_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/add_skill_to_player_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/add_skill_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/delete_skill_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/get_skills_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/skill/update_skill_use_case.dart';
import 'package:team_build_balancer/src/skills/domain/use_cases/teams/generate_teams_use_case.dart';

part 'teams_event.dart';
part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  TeamsBloc({
    required AddPlayerUseCase addPlayerUseCase,
    required AddSkillUseCase addSkillUseCase,
    required AddSkillToPlayerUseCase addSkillToPlayerUseCase,
    required DeleteSkillUseCase deleteSkillUseCase,
    required DeletePlayerUseCase deletePlayerUseCase,
    required UpdateSkillUseCase updateSkillUseCase,
    required UpdatePlayerUseCase updatePlayerUseCase,
    required GetPlayersUseCase getPlayersUseCase,
    required GetSkillsUseCase getSkillsUseCase,
    required GenerateTeamsUseCase generateTeamsUseCase,
  })  : _addPlayerUseCase = addPlayerUseCase,
        _addSkillUseCase = addSkillUseCase,
        _addSkillToPlayerUseCase = addSkillToPlayerUseCase,
        _deleteSkillUseCase = deleteSkillUseCase,
        _deletePlayerUseCase = deletePlayerUseCase,
        _updateSkillUseCase = updateSkillUseCase,
        _updatePlayerUseCase = updatePlayerUseCase,
        _getPlayersUseCase = getPlayersUseCase,
        _getSkillsUseCase = getSkillsUseCase,
        _generateTeamsUseCase = generateTeamsUseCase,
        super(const TeamsInitial()) {
    on<TeamsEvent>((event, emit) {
      emit(const TeamsStateLoading());
    });

    on<AddPlayerEvent>(_addPlayer);
    on<AddSkillEvent>(_addSkill);
    on<AssignSkillToPlayerEvent>(_addSkillToPlayer);
    on<DeleteSkillEvent>(_deleteSkill);
    on<DeletePlayerEvent>(_deletePlayer);
    on<UpdateSkillEvent>(_updateSkill);
    on<UpdatePlayerEvent>(_updatePlayer);
    on<FetchPlayersEvent>(_getPlayers);
    on<FetchSkillsEvent>(_getSkills);
    on<GenerateTeamsEvent>(_generateTeams);
  }

  final AddPlayerUseCase _addPlayerUseCase;
  final AddSkillUseCase _addSkillUseCase;
  final AddSkillToPlayerUseCase _addSkillToPlayerUseCase;
  final DeleteSkillUseCase _deleteSkillUseCase;
  final DeletePlayerUseCase _deletePlayerUseCase;
  final UpdateSkillUseCase _updateSkillUseCase;
  final UpdatePlayerUseCase _updatePlayerUseCase;
  final GetPlayersUseCase _getPlayersUseCase;
  final GetSkillsUseCase _getSkillsUseCase;
  final GenerateTeamsUseCase _generateTeamsUseCase;

  Future<void> _addPlayer(
    AddPlayerEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _addPlayerUseCase.call(
      event.player,
    );
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (player) => emit(const PlayerAddedState()),
    );
  }

  Future<void> _addSkill(
    AddSkillEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _addSkillUseCase.call(
      event.skill,
    );
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (skill) => emit(const SkillAddedState()),
    );
  }

  Future<void> _addSkillToPlayer(
    AssignSkillToPlayerEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final params = SkillToPlayerParams(event.playerId, event.skill);
    final result = await _addSkillToPlayerUseCase.call(
      params,
    );
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (player) => emit(const AddedSkillToPlayerState()),
    );
  }

  Future<void> _deleteSkill(
    DeleteSkillEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _deleteSkillUseCase.call(event.skill);
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (skill) => emit(const SkillDeletedState()),
    );
  }

  Future<void> _deletePlayer(
    DeletePlayerEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _deletePlayerUseCase.call(event.player);
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (player) => emit(const PlayerDeletedState()),
    );
  }

  Future<void> _updateSkill(
    UpdateSkillEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _updateSkillUseCase.call(event.skill);
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (skill) => emit(const SkillUpdatedState()),
    );
  }

  Future<void> _updatePlayer(
    UpdatePlayerEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _updatePlayerUseCase.call(event.player);
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (player) => emit(const PlayerUpdatedState()),
    );
  }

  Future<void> _getPlayers(
    FetchPlayersEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _getPlayersUseCase.call();
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (players) => emit(PlayersAddedState(players: players)),
    );
  }

  Future<void> _getSkills(
    FetchSkillsEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _getSkillsUseCase.call();
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (skills) => emit(SkillsAddedState(skills: skills)),
    );
  }

  Future<void> _generateTeams(
    GenerateTeamsEvent event,
    Emitter<TeamsState> emit,
  ) async {
    final result = await _generateTeamsUseCase.call(event.numTeams);
    result.fold(
      (failure) => emit(TeamsStateError(message: failure.errorMessage)),
      (teams) => emit(TeamsStateLoaded(teams: teams)),
    );
  }

  @override
  void onTransition(Transition<TeamsEvent, TeamsState> transition) {
    super.onTransition(transition);
  }
}
