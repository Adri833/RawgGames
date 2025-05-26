import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawg_games_app/screens/game_detail_screen.dart';
import 'package:rawg_games_app/theme/text_styles.dart';
import 'package:rawg_games_app/utils/date_utils.dart';
import 'package:rawg_games_app/widgets/game_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List games = [];
  List popularGames = [];
  List newReleases = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchInitialGames();
  }

  Future<void> fetchInitialGames() async {
    const apiKey = '3d2a238aa42f4bd4bc26602e0b5c8a0f';

    final popularUrl = Uri.parse(
        'https://api.rawg.io/api/games?ordering=-rating&key=$apiKey&page_size=10');
    final newReleasesUrl = Uri.parse(
        'https://api.rawg.io/api/games?dates=2024-01-01,2025-12-31&ordering=-released&key=$apiKey&page_size=10');

    try {
      final responses = await Future.wait([
        http.get(popularUrl),
        http.get(newReleasesUrl),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        setState(() {
          popularGames = json.decode(responses[0].body)['results'];
          newReleases = json.decode(responses[1].body)['results'];
        });
      }
    } catch (e) {
      // Puedes manejar errores si quieres
    }
  }

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
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      searchGames(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget buildHorizontalList(String title, List data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleLarge),
        const SizedBox(height: 10),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final game = data[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 12),
                child: GameCard(
                  title: game['name'] ?? 'Sin nombre',
                  imageUrl: game['background_image'] ?? '',
                  releaseDate: formatFecha(game['released']),
                  platforms: extractPlatforms(game),
                  onTap: () {
                    final gameId = game['id'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GameDetailScreen(gameId: gameId),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _controller.text.isNotEmpty;

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
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isSearching
                      ? GridView.builder(
                          itemCount: games.length,
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                              releaseDate: formatFecha(game['released']),
                              platforms: extractPlatforms(game),
                              onTap: () {
                                final gameId = game['id'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        GameDetailScreen(gameId: gameId),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : ListView(
                          children: [
                            if (popularGames.isNotEmpty)
                              buildHorizontalList('Juegos populares', popularGames),
                            if (newReleases.isNotEmpty)
                              buildHorizontalList('Novedades', newReleases),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> extractPlatforms(dynamic game) {
  final platforms = game['platforms'] as List<dynamic>? ?? [];

  final Set<String> platformSet = {};

  for (var p in platforms) {
    final name = p['platform']['name'].toString().toLowerCase();

    if (name.contains('playstation')) {
      platformSet.add('playstation');
    } else if (name.contains('xbox')) {
      platformSet.add('xbox');
    } else if (name.contains('pc') || name.contains('windows')) {
      platformSet.add('pc');
    } else if (name.contains('nintendo') || name.contains('switch')) {
      platformSet.add('nintendo');
    } else if (name.contains('ios') || name.contains('mac')) {
      platformSet.add('ios');
    } else if (name.contains('android')) {
      platformSet.add('android');
    }
  }

  return platformSet.toList();
}
