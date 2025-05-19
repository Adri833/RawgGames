import 'package:flutter/material.dart';
import 'package:rawg_games_app/theme/app_colors.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String releaseDate;

  const GameCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del juego
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 140,
                child: Center(child: Icon(Icons.broken_image, color: Colors.white))
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              releaseDate,
              style: const TextStyle(
                color: AppColors.subtitle,
                fontSize: 12,
              ),
            ),
          ),
        ],
      )
    );
  }
}