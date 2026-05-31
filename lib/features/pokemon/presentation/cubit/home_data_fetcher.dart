import '../../data/models/pokemon_list_item_model.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/pokemon_usecases.dart';

class HomeDataFetcher {
  final PokemonUseCases _useCases = PokemonUseCases();
  final Map<String, List<String>> _typePokemonCache = {};

  Future<List<PokemonListItemModel>> applyTypeFilter(
      List<PokemonListItemModel> baseList, String? type) async {
    if (type == null) return baseList;

    List<String> typeNames;
    if (_typePokemonCache.containsKey(type)) {
      typeNames = _typePokemonCache[type]!;
    } else {
      typeNames = await _useCases.getPokemonNamesByType(type);
      _typePokemonCache[type] = typeNames;
    }

    final typeSet = typeNames.toSet();
    return baseList.where((p) => typeSet.contains(p.name.toLowerCase())).toList();
  }

  Future<List<PokemonEntity>> loadDashboardDetails({
    required List<PokemonListItemModel> filteredList,
    required List<PokemonEntity> currentDetails,
    required String? type,
    required String? role,
    required Function(List<PokemonEntity>) onBatchLoaded,
  }) async {
    final updatedDetails = List<PokemonEntity>.from(currentDetails);

    var matching = updatedDetails.where((p) {
      final matchesType = type == null || p.types.contains(type);
      final matchesRole = role == null || p.combatRole == role;
      return matchesType && matchesRole;
    }).toList();

    if (matching.length >= 20 || updatedDetails.length >= filteredList.length) {
      return updatedDetails;
    }

    int startIndex = 0;
    while (matching.length < 20 && startIndex < filteredList.length) {
      final batch = filteredList
          .skip(startIndex)
          .take(20)
          .where((item) => !updatedDetails.any((d) => d.name == item.name))
          .toList();

      if (batch.isEmpty) {
        startIndex += 20;
        continue;
      }

      final newDetails = await _useCases.getMultipleEntities(batch.map((p) => p.name).toList());
      updatedDetails.addAll(newDetails);

      matching = updatedDetails.where((p) {
        final matchesType = type == null || p.types.contains(type);
        final matchesRole = role == null || p.combatRole == role;
        return matchesType && matchesRole;
      }).toList();

      onBatchLoaded(updatedDetails);

      startIndex += 20;
      if (updatedDetails.length > 200) {
        break;
      }
    }
    return updatedDetails;
  }
}
