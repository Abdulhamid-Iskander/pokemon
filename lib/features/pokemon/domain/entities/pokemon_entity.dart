class PokemonEntity {
  final int id;
  final String name;
  final String imageUrl;
  final Map<String, int> stats;
  final List<String> types;
  final int weight;
  final int height;
  final double trueCombatPower;
  final String combatRole;
  final double physicalBias;

  const PokemonEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.stats,
    required this.types,
    required this.weight,
    required this.height,
    required this.trueCombatPower,
    required this.combatRole,
    required this.physicalBias,
  });

  String get capitalizedName =>
      name.isEmpty ? '' : name[0].toUpperCase() + name.substring(1);

  String get primaryType => types.isNotEmpty ? types.first : 'normal';

  int get hp => stats['hp'] ?? 0;
  int get attack => stats['attack'] ?? 0;
  int get defense => stats['defense'] ?? 0;
  int get spAtk => stats['special-attack'] ?? 0;
  int get spDef => stats['special-defense'] ?? 0;
  int get speed => stats['speed'] ?? 0;
  int get totalStats =>
      hp + attack + defense + spAtk + spDef + speed;

  double get weightKg => weight / 10.0;
  double get heightM => height / 10.0;
}
