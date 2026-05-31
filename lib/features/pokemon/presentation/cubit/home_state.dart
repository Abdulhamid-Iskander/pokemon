import '../../data/models/pokemon_list_item_model.dart';
import '../../domain/entities/pokemon_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PokemonListItemModel> allPokemon;
  final List<PokemonListItemModel> filteredPokemon;
  final List<PokemonEntity> dashboardDetails;
  final String searchQuery;
  final String? selectedType;
  final String? selectedRole;
  final PokemonEntity? heroPokemon;
  final bool isLoadingDashboard;

  HomeLoaded({
    required this.allPokemon,
    required this.filteredPokemon,
    required this.dashboardDetails,
    this.searchQuery = '',
    this.selectedType,
    this.selectedRole,
    this.heroPokemon,
    this.isLoadingDashboard = false,
  });

  HomeLoaded copyWith({
    List<PokemonListItemModel>? allPokemon,
    List<PokemonListItemModel>? filteredPokemon,
    List<PokemonEntity>? dashboardDetails,
    String? searchQuery,
    String? selectedType,
    String? selectedRole,
    PokemonEntity? heroPokemon,
    bool? isLoadingDashboard,
    bool clearType = false,
    bool clearRole = false,
  }) {
    return HomeLoaded(
      allPokemon: allPokemon ?? this.allPokemon,
      filteredPokemon: filteredPokemon ?? this.filteredPokemon,
      dashboardDetails: dashboardDetails ?? this.dashboardDetails,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      selectedRole: clearRole ? null : (selectedRole ?? this.selectedRole),
      heroPokemon: heroPokemon ?? this.heroPokemon,
      isLoadingDashboard: isLoadingDashboard ?? this.isLoadingDashboard,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
