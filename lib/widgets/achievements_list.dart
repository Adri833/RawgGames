import 'package:flutter/material.dart';
import 'package:rawg_games_app/theme/text_styles.dart';
import '/models/achievement.dart';

class AchievementsList extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsList({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: achievements.map((achievement) {
        final percentage = achievement.percent;
        final progress = percentage / 100;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          height: 87,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Fondo progresivo
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.08 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Contenido principal
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        achievement.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(achievement.name, style: AppTextStyles.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            achievement.description,
                            style: AppTextStyles.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text('${percentage.toStringAsFixed(1)}%', style: AppTextStyles.titleMedium),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
