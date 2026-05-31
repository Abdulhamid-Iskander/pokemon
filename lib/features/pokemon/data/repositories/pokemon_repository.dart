import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/pokemon_list_item_model.dart';
import '../models/pokemon_detail_model.dart';

class PokemonRepository {
  final RemoteDataSource _remote = RemoteDataSource();
  final LocalDataSource _local = LocalDataSource();

  Future<List<PokemonListItemModel>> getMasterList() async {
    if (_local.isCached) {
      return _local.getAllPokemon();
    }
    final list = await _remote.fetchMasterList();
    await _local.saveMasterList(list);
    return list;
  }

  List<PokemonListItemModel> searchOffline(String query) {
    return _local.search(query);
  }

  Future<PokemonDetailModel> getPokemonDetail(String nameOrId) async {
    return _remote.fetchPokemonDetail(nameOrId);
  }

  Future<List<PokemonDetailModel>> getMultipleDetails(
      List<String> namesOrIds) async {
    return _remote.fetchMultipleDetails(namesOrIds);
  }

  Future<List<PokemonListItemModel>> refreshMasterList() async {
    final list = await _remote.fetchMasterList();
    await _local.saveMasterList(list);
    return list;
  }

  Future<List<String>> getPokemonNamesByType(String typeName) async {
    return _remote.fetchPokemonNamesByType(typeName);
  }
}
