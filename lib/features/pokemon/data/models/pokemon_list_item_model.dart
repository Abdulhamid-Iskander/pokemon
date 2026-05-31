import 'package:hive/hive.dart';

part 'pokemon_list_item_model.g.dart';

@HiveType(typeId: 0)
class PokemonListItemModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  PokemonListItemModel({
    required this.name,
    required this.url,
  });

  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) {
    return PokemonListItemModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  int get id {
    final parts = url.split('/');
    final idStr = parts.lastWhere((p) => p.isNotEmpty, orElse: () => '0');
    return int.tryParse(idStr) ?? 0;
  }

  String get capitalizedName =>
      name.isEmpty ? '' : name[0].toUpperCase() + name.substring(1);
}
