import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/pokemon_usecases.dart';
import '../../../../../core/utils/debouncer.dart';
import 'home_state.dart';
import 'home_data_fetcher.dart';

class HomeCubit extends Cubit<HomeState> {
  final PokemonUseCases _useCases = PokemonUseCases();
  final Debouncer _debouncer = Debouncer();
  final HomeDataFetcher _fetcher = HomeDataFetcher();

  HomeCubit() : super(HomeInitial());

  Future<void> loadInitialData() async {
    emit(HomeLoading());
    try {
      final list = await _useCases.fetchMasterList();
      emit(HomeLoaded(
        allPokemon: list,
        filteredPokemon: list,
        dashboardDetails: [],
        isLoadingDashboard: true,
      ));
      await _loadDetails(list, null, null);
    } catch (e) {
      emit(HomeError('Failed to load Pokémon: ${e.toString()}'));
    }
  }

  Future<void> _loadDetails(List<PokemonListItemModel> filteredList, String? type, String? role) async {
    try {
      final current = state;
      if (current is! HomeLoaded) return;

      await _fetcher.loadDashboardDetails(
        filteredList: filteredList,
        currentDetails: current.dashboardDetails,
        type: type,
        role: role,
        onBatchLoaded: (updatedDetails) {
          final updated = state;
          if (updated is HomeLoaded) {
            final hero = updatedDetails.isEmpty
                ? null
                : updatedDetails.reduce((a, b) => a.trueCombatPower > b.trueCombatPower ? a : b);
            emit(updated.copyWith(
              dashboardDetails: updatedDetails,
              heroPokemon: hero,
            ));
          }
        },
      );

      final finalState = state;
      if (finalState is HomeLoaded) {
        emit(finalState.copyWith(isLoadingDashboard: false));
      }
    } catch (_) {
      final finalState = state;
      if (finalState is HomeLoaded) {
        emit(finalState.copyWith(isLoadingDashboard: false));
      }
    }
  }

  void onSearchChanged(String query) {
    _debouncer.run(() async {
      final current = state;
      if (current is! HomeLoaded) return;

      emit(current.copyWith(isLoadingDashboard: true, searchQuery: query));

      try {
        final base = _useCases.searchPokemon(query);
        final filtered = await _fetcher.applyTypeFilter(base, current.selectedType);

        emit(current.copyWith(
          searchQuery: query,
          filteredPokemon: filtered,
          isLoadingDashboard: true,
        ));

        await _loadDetails(filtered, current.selectedType, current.selectedRole);
      } catch (_) {
        final updated = state;
        if (updated is HomeLoaded) {
          emit(updated.copyWith(isLoadingDashboard: false));
        }
      }
    });
  }

  Future<void> onTypeFilterSelected(String? type) async {
    final current = state;
    if (current is! HomeLoaded) return;

    final newType = current.selectedType == type ? null : type;

    emit(current.copyWith(
      selectedType: newType,
      isLoadingDashboard: true,
      clearType: newType == null,
    ));

    try {
      final base = _useCases.searchPokemon(current.searchQuery);
      final filtered = await _fetcher.applyTypeFilter(base, newType);

      emit(current.copyWith(
        selectedType: newType,
        filteredPokemon: filtered,
        isLoadingDashboard: true,
        clearType: newType == null,
      ));

      await _loadDetails(filtered, newType, current.selectedRole);
    } catch (_) {
      final updated = state;
      if (updated is HomeLoaded) {
        emit(updated.copyWith(isLoadingDashboard: false));
      }
    }
  }

  Future<void> onRoleFilterSelected(String? role) async {
    final current = state;
    if (current is! HomeLoaded) return;

    final newRole = current.selectedRole == role ? null : role;

    emit(current.copyWith(
      selectedRole: newRole,
      isLoadingDashboard: true,
      clearRole: newRole == null,
    ));

    try {
      final base = _useCases.searchPokemon(current.searchQuery);
      final filtered = await _fetcher.applyTypeFilter(base, current.selectedType);

      emit(current.copyWith(
        selectedRole: newRole,
        filteredPokemon: filtered,
        isLoadingDashboard: true,
        clearRole: newRole == null,
      ));

      await _loadDetails(filtered, current.selectedType, newRole);
    } catch (_) {
      final updated = state;
      if (updated is HomeLoaded) {
        emit(updated.copyWith(isLoadingDashboard: false));
      }
    }
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}
