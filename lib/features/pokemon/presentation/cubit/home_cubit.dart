import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/pokemon_usecases.dart';
import '../../../../../core/utils/debouncer.dart';
import 'home_state.dart';
import 'home_data_fetcher.dart';

export 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PokemonUseCases _useCases = PokemonUseCases();
  final Debouncer _debouncer = Debouncer();
  final HomeDataFetcher _fetcher = HomeDataFetcher();

  HomeCubit() : super(HomeInitial());

  Future<void> loadInitialData() async {
    emit(HomeLoading());
    try {
      final list = await _useCases.fetchMasterList();
      emit(HomeLoaded(allPokemon: list, filteredPokemon: list, dashboardDetails: [], isLoadingDashboard: true));
      await _loadDetails(list, null, null);
    } catch (e) {
      emit(HomeError('Failed to load Pokémon: ${e.toString()}'));
    }
  }

  void _stopLoading() {
    final s = state;
    if (s is HomeLoaded) emit(s.copyWith(isLoadingDashboard: false));
  }

  Future<void> _loadDetails(List<PokemonListItemModel> filteredList, String? type, String? role) async {
    try {
      final curr = state; if (curr is! HomeLoaded) return;
      await _fetcher.loadDashboardDetails(
        filteredList: filteredList,
        currentDetails: curr.dashboardDetails,
        type: type,
        role: role,
        onBatchLoaded: (updatedDetails) {
          final updated = state;
          if (updated is HomeLoaded) {
            final hero = updatedDetails.isEmpty ? null : updatedDetails.reduce((a, b) => a.trueCombatPower > b.trueCombatPower ? a : b);
            emit(updated.copyWith(dashboardDetails: updatedDetails, heroPokemon: hero));
          }
        },
      );
      _stopLoading();
    } catch (_) {
      _stopLoading();
    }
  }

  void onSearchChanged(String query) {
    _debouncer.run(() async {
      final curr = state; if (curr is! HomeLoaded) return;
      emit(curr.copyWith(isLoadingDashboard: true, searchQuery: query));
      try {
        final filtered = await _fetcher.applyTypeFilter(_useCases.searchPokemon(query), curr.selectedType);
        emit(curr.copyWith(searchQuery: query, filteredPokemon: filtered, isLoadingDashboard: true));
        await _loadDetails(filtered, curr.selectedType, curr.selectedRole);
      } catch (_) {
        _stopLoading();
      }
    });
  }

  Future<void> onTypeFilterSelected(String? type) async {
    final curr = state; if (curr is! HomeLoaded) return;
    final newType = curr.selectedType == type ? null : type;
    emit(curr.copyWith(selectedType: newType, isLoadingDashboard: true, clearType: newType == null));
    try {
      final filtered = await _fetcher.applyTypeFilter(_useCases.searchPokemon(curr.searchQuery), newType);
      emit(curr.copyWith(selectedType: newType, filteredPokemon: filtered, isLoadingDashboard: true, clearType: newType == null));
      await _loadDetails(filtered, newType, curr.selectedRole);
    } catch (_) {
      _stopLoading();
    }
  }

  Future<void> onRoleFilterSelected(String? role) async {
    final curr = state; if (curr is! HomeLoaded) return;
    final newRole = curr.selectedRole == role ? null : role;
    emit(curr.copyWith(selectedRole: newRole, isLoadingDashboard: true, clearRole: newRole == null));
    try {
      final filtered = await _fetcher.applyTypeFilter(_useCases.searchPokemon(curr.searchQuery), curr.selectedType);
      emit(curr.copyWith(selectedRole: newRole, filteredPokemon: filtered, isLoadingDashboard: true, clearRole: newRole == null));
      await _loadDetails(filtered, curr.selectedType, newRole);
    } catch (_) {
      _stopLoading();
    }
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}
