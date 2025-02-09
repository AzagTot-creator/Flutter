import 'dart:math';

class Mob {
  final String name;
  final int level;
  final int maxHealth;
  int currentHealth;
  final int experience;
  final int minDamage;
  final int maxDamage;
  final String imagePath;

  Mob({
    required this.name,
    required this.level,
    required this.maxHealth,
    required this.experience,
    required this.minDamage,
    required this.maxDamage,
    required this.imagePath,
  }) : currentHealth = maxHealth; // Начальное здоровье равно макс. здоровью

  void dropLoot(Function(int) addExperienceCallback) {
    addExperienceCallback(experience); // Отдаем опыт в callback
  }

  // Метод для атаки на персонажа
  int attack() {
    final random = Random();
    return random.nextInt(maxDamage - minDamage + 1) + minDamage;
  }
}
