import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawg_games_app/theme/text_styles.dart';

class GameDetailScreen extends StatefulWidget {
  final int gameId;

  const GameDetailScreen({super.key, required this.gameId});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  Map<String, dynamic>? game;
  bool isLoading = true;

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
        setState(() {
          game = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error al obtener detalles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game?['name'] ?? 'Cargando...'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : game == null
              ? const Center(child: Text('Error al cargar detalles.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      if (game!['background_image'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(game!['background_image']),
                        ),

                      const SizedBox(height: 16),

                      Text(
                        game!['name'],
                        style: AppTextStyles.titleLarge,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Fecha de lanzamiento: ${game!['released'] ?? 'Desconocida'}',
                        style: AppTextStyles.subtitle,
                      ),

                      const SizedBox(height: 16),

                        Text(
                          game!['description_raw'] ?? '',
                          style: AppTextStyles.body,
                        ),

                      const SizedBox(height: 16),

                      Text(
                        'Metacritic:',
                        style: AppTextStyles.subtitleBold,
                      ),
                      Text(
                        game!['metacritic']?.toString() ?? 'No disponible',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
    );
  }
}
