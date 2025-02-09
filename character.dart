class Character {
  final String name;
  final String className;
  final int level;
  final int experience;
  final int maxExperience;
  final int strength;
  final int agility;
  final int intelligence;
  final int stamina;
  final int luck;
  final int currentHealth;
  final int maxHealth;
  final int currentMana;
  final int maxMana;
  final int adena;

  const Character({
    required this.name,
    required this.className,
    this.level = 1,
    this.experience = 0,
    this.maxExperience = 1000,
    this.strength = 10,
    this.agility = 10,
    this.intelligence = 10,
    this.stamina = 10,
    this.luck = 10,
    this.currentHealth = 100,
    this.maxHealth = 100,
    this.currentMana = 50,
    this.maxMana = 50,
    this.adena = 0,
  });

  // Создаем пустого персонажа для инициализации
  factory Character.empty() => const Character(
        name: '',
        className: '',
      );

  // Метод для копирования с изменениями
  Character copyWith({
    String? name,
    String? className,
    int? level,
    int? experience,
    int? maxExperience,
    int? strength,
    int? agility,
    int? intelligence,
    int? stamina,
    int? luck,
    int? currentHealth,
    int? maxHealth,
    int? currentMana,
    int? maxMana,
    int? adena,
  }) {
    return Character(
      name: name ?? this.name,
      className: className ?? this.className,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      maxExperience: maxExperience ?? this.maxExperience,
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      intelligence: intelligence ?? this.intelligence,
      stamina: stamina ?? this.stamina,
      luck: luck ?? this.luck,
      currentHealth: currentHealth ?? this.currentHealth,
      maxHealth: maxHealth ?? this.maxHealth,
      currentMana: currentMana ?? this.currentMana,
      maxMana: maxMana ?? this.maxMana,
      adena: adena ?? this.adena,
    );
  }

  // Рассчитываем прогресс уровня
  double get experienceProgress => experience / maxExperience;

  // Метод для проверки валидности персонажа
  bool get isValid => name.isNotEmpty && className.isNotEmpty;

  // Можно добавить методы для сериализации/десериализации,
  // если планируется сохранение в SharedPreferences
}