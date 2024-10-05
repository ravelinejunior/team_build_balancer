import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:team_build_balancer/src/sports/domain/model/sports.dart';
import 'package:team_build_balancer/src/sports/domain/use_cases/get_sport_by_id_use_case.dart';
import 'package:team_build_balancer/src/sports/domain/use_cases/get_sports_use_case.dart';

part 'sports_event.dart';
part 'sports_state.dart';

class SportsBloc extends Bloc<SportsEvent, SportsState> {
  SportsBloc({
    required GetSportsUseCase getSportsUseCase,
    required GetSportByIdUseCase getSportByIdUseCase,
  })  : _getSportsUseCase = getSportsUseCase,
        _getSportByIdUseCase = getSportByIdUseCase,
        super(const SportsInitial()) {
    on<SportsEvent>((event, emit) {
      emit(const SportsLoading());
    });

    on<GetSportsEvent>(_getSports);
    on<GetSportByIdEvent>(_getSportById);
  }

  final GetSportsUseCase _getSportsUseCase;
  final GetSportByIdUseCase _getSportByIdUseCase;

  Future<void> _getSports(
    GetSportsEvent event,
    Emitter<SportsState> emit,
  ) async {
    final result = await _getSportsUseCase.call();
    result.fold(
      (failure) => emit(SportsError(failure.errorMessage)),
      (sports) => emit(SportsListLoaded(sports)),
    );
  }

  Future<void> _getSportById(
    GetSportByIdEvent event,
    Emitter<SportsState> emit,
  ) async {
    final result = await _getSportByIdUseCase.call(
      event.id,
    );
    result.fold(
      (failure) => emit(SportsError(failure.errorMessage)),
      (sport) => emit(SportSelectedByIdLoaded(sport)),
    );
  }
}
