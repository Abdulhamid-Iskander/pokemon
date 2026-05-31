import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/pokemon_usecases.dart';

abstract class HeadToHeadState {}

class H2HInitial extends HeadToHeadState {}

class H2HLoading extends HeadToHeadState {}

class H2HLoaded extends HeadToHeadState {
  final PokemonEntity? pokemonA;
  final PokemonEntity? pokemonB;
  final PokemonEntity? winner;
  final Map<String, int>? statDiff;

  H2HLoaded({
    this.pokemonA,
    this.pokemonB,
    this.winner,
    this.statDiff,
  });
}

class H2HError extends HeadToHeadState {
  final String message;
  H2HError(this.message);
}

class HeadToHeadCubit extends Cubit<HeadToHeadState> {
  final PokemonUseCases _useCases = PokemonUseCases();

  HeadToHeadCubit() : super(H2HInitial());

  Future<void> selectPokemon(String nameOrId, {required bool isA}) async {
    final current = state;
    PokemonEntity? currentA;
    PokemonEntity? currentB;
    if (current is H2HLoaded) {
      currentA = current.pokemonA;
      currentB = current.pokemonB;
    }

    emit(H2HLoading());
    try {
      final entity = await _useCases.getPokemonEntity(nameOrId);

      final newA = isA ? entity : currentA;
      final newB = isA ? currentB : entity;

      PokemonEntity? winner;
      Map<String, int>? diff;

      if (newA != null && newB != null) {
        winner = _useCases.headToHeadWinner(newA, newB);
        diff = _useCases.compareStats(newA, newB);
      }

      emit(H2HLoaded(
        pokemonA: newA,
        pokemonB: newB,
        winner: winner,
        statDiff: diff,
      ));
    } catch (e) {
      emit(H2HError('Failed to load fighter: ${e.toString()}'));
    }
  }

  void reset() => emit(H2HInitial());
}
