import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawg_games_app/models/achievement.dart';
import 'package:rawg_games_app/theme/text_styles.dart';
import 'package:rawg_games_app/utils/date_utils.dart';
import 'package:rawg_games_app/utils/translation_utils.dart';
import 'package:rawg_games_app/widgets/achievements_list.dart';
import 'package:rawg_games_app/services/achievement_service.dart';


class GameDetailScreen extends StatefulWidget {
  final int gameId;

  const GameDetailScreen({super.key, required this.gameId});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  Map<String, dynamic>? game;
  String? descripcionTraducida;
  bool isLoading = true;
  List<Achievement> achievements = [];
  bool isLoadingAchievements = true;

  

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  Future<void> fetchGameDetails() async {
    final url = Uri.parse(
      'https://api.rawg.io/api/games/${widget.gameId}?key=3d2a238aa42f4bd4bc26602e0b5c8a0f',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          game = data;
          isLoading = false;
        });

        // Traducción asincrónica sin bloquear la carga inicial
        final traduccion = await traducirTexto(data['description_raw'] ?? '');
        setState(() {
          descripcionTraducida = traduccion;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }

      // Cargar logros
      final loadedAchievements = await AchievementService.fetchAchievements(widget.gameId);
      setState(() {
        achievements = loadedAchievements;
        isLoadingAchievements = false;
      });
    } catch (e) {
      print('Error en fetchGameDetails: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final metacriticScore = game?['metacritic'] ?? 0;

    Color getColorByScore(int score) {
      if (score == 0) return Colors.grey;
      if (score < 40) return Colors.red;
      if (score < 75) return Colors.orange;
      return Colors.green;
    }
                    
    return Scaffold(
      appBar: AppBar(title: Text(game?['name'] ?? 'Cargando...')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : game == null
              ? const Center(child: Text('Error al cargar detalles.'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (game!['background_image'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(game!['background_image']),
                      ),

                    const SizedBox(height: 16),

                    Text(game!['name'], style: AppTextStyles.titleLarge),

                    const SizedBox(height: 8),

                    Text(
                      'Fecha de lanzamiento: ${formatFecha(game!['released'])}',
                      style: AppTextStyles.subtitle,
                    ),

                    const SizedBox(height: 16),

                    descripcionTraducida != null
                        ? Text(descripcionTraducida!, style: AppTextStyles.body, textAlign: TextAlign.justify)
                        : Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Traduciendo descripción...',
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                        
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/ic_metacritic.png', width: 80, height: 80),                      

                        const SizedBox(width: 8),

                        SizedBox(
                          width: 75,
                          height: 75,

                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: getColorByScore(metacriticScore),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              metacriticScore?.toString() ?? 'No disponible',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 24),

                    Text('Logros', style: AppTextStyles.titleLarge),

                    const SizedBox(height: 8),
                    
                    if (isLoadingAchievements)
                      const Center(child: CircularProgressIndicator())
                    else if (achievements.isEmpty)
                      const Text('No hay logros disponibles.')
                    else
                      AchievementsList(achievements: achievements),

                  ],
                ),
              ),
    );
  }
}
