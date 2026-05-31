import '../../data/models/pokemon_detail_model.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../entities/pokemon_entity.dart';

class PokemonUseCases {
  final PokemonRepository _repository = PokemonRepository();

  Future<List<PokemonListItemModel>> fetchMasterList() =>
      _repository.getMasterList();

  List<PokemonListItemModel> searchPokemon(String query) =>
      _repository.searchOffline(query);

  Future<PokemonEntity> getPokemonEntity(String nameOrId) async {
    final model = await _repository.getPokemonDetail(nameOrId);
    return _toEntity(model);
  }

  Future<List<PokemonEntity>> getMultipleEntities(
      List<String> namesOrIds) async {
    final models = await _repository.getMultipleDetails(namesOrIds);
    return models.map(_toEntity).toList();
  }

  PokemonEntity _toEntity(PokemonDetailModel m) {
    return PokemonEntity(
      id: m.id,
      name: m.name,
      imageUrl: m.imageUrl,
      stats: {
        'hp': m.hp,
        'attack': m.attack,
        'defense': m.defense,
        'special-attack': m.spAtk,
        'special-defense': m.spDef,
        'speed': m.speed,
      },
      types: m.types.map((t) => t.name).toList(),
      weight: m.weight,
      height: m.height,
      trueCombatPower: m.trueCombatPower,
      combatRole: m.combatRole,
      physicalBias: m.physicalBias,
    );
  }

  PokemonEntity headToHeadWinner(
      PokemonEntity a, PokemonEntity b) {
    return a.trueCombatPower >= b.trueCombatPower ? a : b;
  }

  Map<String, int> compareStats(PokemonEntity a, PokemonEntity b) {
    return {
      'hp': a.hp - b.hp,
      'attack': a.attack - b.attack,
      'defense': a.defense - b.defense,
      'special-attack': a.spAtk - b.spAtk,
      'special-defense': a.spDef - b.spDef,
      'speed': a.speed - b.speed,
    };
  }

  Future<List<String>> getPokemonNamesByType(String typeName) =>
      _repository.getPokemonNamesByType(typeName);
}
