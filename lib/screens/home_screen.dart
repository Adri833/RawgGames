import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawg_games_app/screens/game_detail_screen.dart';
import 'dart:convert';

import 'package:rawg_games_app/widgets/game_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List games = [];
  bool isLoading = false;

  Future<void> searchGames(String query) async {
    if (query.isEmpty) {
      setState(() => games = []);
      return;
    }

    setState(() => isLoading = true);

    const apiKey = '3d2a238aa42f4bd4bc26602e0b5c8a0f';
    final url = Uri.parse(
      'https://api.rawg.io/api/games?search=$query&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          games = data['results'];
          isLoading = false;
        });
      } else {
        setState(() {
          games = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        games = [];
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    // Espera 500ms desde la última tecla antes de llamar a la API
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchGames(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar videojuegos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Escribe un videojuego...',
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                  child: GridView.builder(
                    itemCount: games.length,
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return GameCard(
                        title: game['name'] ?? 'Sin nombre',
                        imageUrl: game['background_image'] ?? '',
                        releaseDate: game['released'] ?? 'Desconocido',
                        onTap: () {
                          final gameId = game['id'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameDetailScreen(gameId: gameId),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
