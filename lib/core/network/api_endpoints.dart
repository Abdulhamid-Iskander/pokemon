class ApiEndpoints {
  
  static String masterList({int limit = 10000, int offset = 0}) =>
      'pokemon?limit=$limit&offset=$offset';

  static String pokemonDetail(String nameOrId) => 'pokemon/$nameOrId/';
}
