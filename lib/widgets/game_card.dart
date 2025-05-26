import 'package:flutter/material.dart';
import 'package:rawg_games_app/theme/app_colors.dart';
import 'package:rawg_games_app/theme/text_styles.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String releaseDate;
  final List<String> platforms;
  final VoidCallback? onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    required this.platforms,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: platforms
                    .map((p) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: _platformIcon(p),
                        ))
                    .toList(),
              ),
            ),
          ],
        )
      ),
    );
  }
}

Widget _platformIcon(String platform) {
  final name = platform.toLowerCase();

  if (name.contains('pc')) {
    return Image.asset('assets/icons/pc.png', width: 30, height: 30);
  } else if (name.contains('playstation')) {
    return Image.asset('assets/icons/playstation.png', width: 30, height: 30);
  } else if (name.contains('xbox')) {
    return Image.asset('assets/icons/xbox.png', width: 30, height: 30);
  } else if (name.contains('nintendo')) {
    return Image.asset('assets/icons/nintendo.png', width: 30, height: 30);
  } else if (name.contains('ios') || name.contains('mac')) {
    return Image.asset('assets/icons/apple.png', width: 30, height: 30);
  } else if (name.contains('android')) {
    return Image.asset('assets/icons/android.png', width: 30, height: 30);
  } else {
    return Image.asset('assets/icons/default.png', width: 30, height: 30);
  }
}