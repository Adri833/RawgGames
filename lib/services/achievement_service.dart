import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/achievement.dart';

class AchievementService {
  static const String _apiKey = '3d2a238aa42f4bd4bc26602e0b5c8a0f';

  static Future<List<Achievement>> fetchAchievements(int gameId) async {
  const String baseUrl = 'https://api.rawg.io/api/games';
  const int pageSize = 20;
  int page = 1;
  bool hasNext = true;
  List<Achievement> allAchievements = [];

  while (hasNext) {
    final url = Uri.parse(
      '$baseUrl/$gameId/achievements?key=$_apiKey&page=$page&page_size=$pageSize',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      allAchievements.addAll(results.map((json) => Achievement.fromJson(json)));

      hasNext = data['next'] != null;
      page++;
    } else {
      throw Exception('Error al cargar logros: ${response.statusCode}');
    }
  }
  // Ordenar logros por porcentaje descendente
  allAchievements.sort((a, b) => b.percent.compareTo(a.percent));

  return allAchievements;
}

}
