import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/pokemon_usecases.dart';

abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final PokemonEntity pokemon;
  DetailLoaded(this.pokemon);
}

class DetailError extends DetailState {
  final String message;
  DetailError(this.message);
}

class DetailCubit extends Cubit<DetailState> {
  final PokemonUseCases _useCases = PokemonUseCases();

  DetailCubit() : super(DetailInitial());

  Future<void> loadPokemon(String nameOrId) async {
    emit(DetailLoading());
    try {
      final entity = await _useCases.getPokemonEntity(nameOrId);
      emit(DetailLoaded(entity));
    } catch (e) {
      emit(DetailError('Failed to load details: ${e.toString()}'));
    }
  }
}
