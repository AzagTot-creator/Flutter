// Файл: screens/game/stats_panel.dart
import 'package:flutter/material.dart';
import 'package:lineage3/widgets/stat_widget.dart';

class StatsPanel extends StatelessWidget {
  final String characterName;
  final int adena;
  final int currentHealth;
  final int maxHealth;
  final int level;
  final double experiencePercentage;
  final int currentMana;
  final int maxMana;

  const StatsPanel({
    super.key,
    required this.characterName,
    required this.adena,
    required this.currentHealth,
    required this.maxHealth,
    required this.level,
    required this.experiencePercentage,
    required this.currentMana,
    required this.maxMana,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color.fromARGB(200, 0, 0, 0),
      child: Column(
        children: [
          // Первая строка: имя персонажа и количество адены
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                characterName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Adena: $adena',
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Вторая строка: здоровье, уровень, опыт и мана
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatWidget(
                label: 'Здоровье',
                value: '$currentHealth/$maxHealth',
                isValueBelow: true,
              ),
              StatWidget(
                label: 'Уровень',
                count: level,
                isValueBelow: true,
              ),
              StatWidget(
                label: 'Опыт',
                value: '${experiencePercentage.toStringAsFixed(1)}%',
                isValueBelow: true,
              ),
              StatWidget(
                label: 'Мана',
                value: '$currentMana/$maxMana',
                isValueBelow: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
