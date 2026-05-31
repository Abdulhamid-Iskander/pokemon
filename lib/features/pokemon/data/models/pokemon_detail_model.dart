class PokemonStat {
  final String name;
  final int baseStat;

  const PokemonStat({required this.name, required this.baseStat});
}

class PokemonType {
  final String name;

  const PokemonType({required this.name});
}

class PokemonDetailModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<PokemonStat> stats;
  final List<PokemonType> types;
  final int weight;
  final int height;

  const PokemonDetailModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.stats,
    required this.types,
    required this.weight,
    required this.height,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    
    final rawStats = json['stats'] as List<dynamic>;
    final stats = rawStats.map((s) {
      return PokemonStat(
        name: s['stat']['name'] as String,
        baseStat: s['base_stat'] as int,
      );
    }).toList();

    final rawTypes = json['types'] as List<dynamic>;
    final types = rawTypes.map((t) {
      return PokemonType(name: t['type']['name'] as String);
    }).toList();

    final sprites = json['sprites'] as Map<String, dynamic>;
    final other = sprites['other'] as Map<String, dynamic>?;
    final officialArtwork = other?['official-artwork'] as Map<String, dynamic>?;
    final imageUrl =
        officialArtwork?['front_default'] as String? ?? '';

    return PokemonDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: imageUrl,
      stats: stats,
      types: types,
      weight: json['weight'] as int,
      height: json['height'] as int,
    );
  }

  int _getStat(String statName) {
    return stats
        .firstWhere((s) => s.name == statName,
            orElse: () => const PokemonStat(name: '', baseStat: 0))
        .baseStat;
  }

  int get hp => _getStat('hp');
  int get attack => _getStat('attack');
  int get defense => _getStat('defense');
  int get spAtk => _getStat('special-attack');
  int get spDef => _getStat('special-defense');
  int get speed => _getStat('speed');

  int get totalStats => hp + attack + defense + spAtk + spDef + speed;

  double get trueCombatPower {
    final maxAtk = attack > spAtk ? attack : spAtk;
    return (maxAtk * 1.5) + (speed * 1.2) + ((hp * defense) / 100.0);
  }

  double get physicalBias {
    final total = attack + spAtk;
    if (total == 0) return 0.5;
    return attack / total;
  }

  String get combatRole {
    if (defense > 90 && hp > 80) return 'Tank';
    if (speed > 100 && attack < 80 && spAtk < 80) return 'Speedster';
    if ((attack > 110 || spAtk > 110) && defense < 70) return 'Glass Cannon';
    return 'Balanced';
  }

  String get capitalizedName =>
      name.isEmpty ? '' : name[0].toUpperCase() + name.substring(1);

  String get primaryType => types.isNotEmpty ? types.first.name : 'normal';

  double get weightKg => weight / 10.0;

  double get heightM => height / 10.0;
}
