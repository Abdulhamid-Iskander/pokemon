import 'package:hive_flutter/hive_flutter.dart';
import '../models/pokemon_list_item_model.dart';

class LocalDataSource {
  static const String _boxName = 'pokemon_master_list';

  Box<PokemonListItemModel> get _box =>
      Hive.box<PokemonListItemModel>(_boxName);

  bool get isCached => _box.isNotEmpty;

  Future<void> saveMasterList(List<PokemonListItemModel> list) async {
    await _box.clear();
    final map = {
      for (int i = 0; i < list.length; i++) i.toString(): list[i]
    };
    await _box.putAll(map);
  }

  List<PokemonListItemModel> getAllPokemon() {
    return _box.values.toList();
  }

  List<PokemonListItemModel> search(String query) {
    if (query.isEmpty) return getAllPokemon();
    final q = query.toLowerCase().trim();
    return _box.values
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }
}
