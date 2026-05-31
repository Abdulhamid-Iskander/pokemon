import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/pokemon_list_item_model.dart';
import '../models/pokemon_detail_model.dart';

class RemoteDataSource {
  final Dio _dio = ApiClient.instance;

  Future<List<PokemonListItemModel>> fetchMasterList() async {
    final response = await _dio.get(ApiEndpoints.masterList());
    final results = response.data['results'] as List<dynamic>;
    return results
        .map((item) =>
            PokemonListItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<PokemonDetailModel> fetchPokemonDetail(String nameOrId) async {
    final response =
        await _dio.get(ApiEndpoints.pokemonDetail(nameOrId));
    return PokemonDetailModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<List<PokemonDetailModel>> fetchMultipleDetails(
      List<String> namesOrIds) async {
    final futures =
        namesOrIds.map((id) => fetchPokemonDetail(id)).toList();
    return Future.wait(futures);
  }

  Future<List<String>> fetchPokemonNamesByType(String typeName) async {
    final response = await _dio.get('type/$typeName/');
    final pokemonList = response.data['pokemon'] as List<dynamic>;
    return pokemonList
        .map((p) => p['pokemon']['name'] as String)
        .toList();
  }
}
