import 'package:flutter/material.dart';
import 'package:rawg_games_app/theme/app_colors.dart';
import 'package:rawg_games_app/theme/text_styles.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String releaseDate;
  final VoidCallback? onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                style: AppTextStyles.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                releaseDate,
                style: AppTextStyles.subtitle,
              ),
            ),
          ],
        )
      ),
    );
  }
}