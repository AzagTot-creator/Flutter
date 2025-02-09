import 'package:flutter/material.dart';
import 'package:lineage3/screens/game/settings_tab.dart' as settings_tab;
import 'package:lineage3/widgets/background_screen.dart';
import 'stats_panel.dart';
import 'bottom_nav.dart';
import 'character_tab/character_tab.dart';
import 'package:lineage3/services/character_service.dart';
import 'package:lineage3/screens/game/battle_tab/battle_tab.dart';
import 'package:lineage3/models/mob.dart';

class GameScreen extends StatefulWidget {
  final String characterId;
  final CharacterService characterService;

  const GameScreen({
    super.key,
    required this.characterId,
    required this.characterService,
  });

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  String _selectedButton = 'персонаж';
  String selectedBattleType = 'Фарм. Зоны';
  late Map<String, dynamic> _characterData;

  int get _userLevel => _characterData['level'] ?? 1;
  int get _userExperience => _characterData['experience'] ?? 0;
  Map<String, int> get _userAttributes =>
      Map<String, int>.from(_characterData['attributes'] ?? {});
  Map<String, int> get _userCharacteristics =>
      Map<String, int>.from(_characterData['characteristics'] ?? {});
  int get _adena => _characterData['adena'] ?? 0;

  int availableAttributes = 5;
  late AnimationController _regenController;

  late double healthRegenRate;
  late double manaRegenRate;
  late double currentHealthRegen;
  late double currentManaRegen;

  void onMobDefeated(Mob mob) {
  mob.dropLoot(addExperience); // Передаем метод addExperience
}

  @override
  void initState() {
    super.initState();
    _characterData = {};
    _loadCharacterData();

    healthRegenRate = 5;
    manaRegenRate = 2.5;
    currentHealthRegen = 0;
    currentManaRegen = 0;

    _regenController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_regenerateHealthAndMana);

    _regenController.repeat();
  }

  Future<void> _loadCharacterData() async {
    try {
      final data =
          await widget.characterService.getCharacterData(widget.characterId);
      if (data != null) {
        setState(() {
          _characterData = data;
          availableAttributes = _characterData['availableAttributes'] ?? 5;
        });
      }
    } catch (e) {
      debugPrint('Error loading character data: $e');
    }
  }

  Future<void> _updateCharacterData(Map<String, dynamic> updates) async {
    try {
      final updatesToSend = <String, dynamic>{};

      updates.forEach((key, value) {
        if (key.contains('.')) {
          final keys = key.split('.');
          final nestedKey = keys[0];
          final nestedField = keys[1];

          if (updatesToSend.containsKey(nestedKey)) {
            updatesToSend[nestedKey][nestedField] = value;
          } else {
            updatesToSend[nestedKey] = {nestedField: value};
          }
        } else {
          updatesToSend[key] = value;
        }
      });

      await widget.characterService
          .updateCharacterField(widget.characterId, updatesToSend);
    } catch (e) {
      debugPrint('Error updating character data: $e');
    }
  }

  void _regenerateHealthAndMana() {
    setState(() {
      bool healthUpdated = false;
      bool manaUpdated = false;

      currentHealthRegen += healthRegenRate / 60;
      if (currentHealthRegen >= 1) {
        final newCharacteristics = Map<String, int>.from(_userCharacteristics);
        int newHealth = (newCharacteristics['currentHealth']! +
                currentHealthRegen.floor())
            .clamp(0, newCharacteristics['health']!);

        if (newCharacteristics['currentHealth'] != newHealth) {
          newCharacteristics['currentHealth'] = newHealth;
          healthUpdated = true;
        }

        currentHealthRegen %= 1;
        _characterData['characteristics'] = newCharacteristics;
      }

      currentManaRegen += manaRegenRate / 60;
      if (currentManaRegen >= 1) {
        final newCharacteristics = Map<String, int>.from(_userCharacteristics);
        int newMana = (newCharacteristics['currentMana']! +
                currentManaRegen.floor())
            .clamp(0, newCharacteristics['mana']!);

        if (newCharacteristics['currentMana'] != newMana) {
          newCharacteristics['currentMana'] = newMana;
          manaUpdated = true;
        }

        currentManaRegen %= 1;
        _characterData['characteristics'] = newCharacteristics;
      }

      if (healthUpdated || manaUpdated) {
        _updateCharacterData({'characteristics': _characterData['characteristics']});
      }
    });
  }

  void addExperience(int amount) {
    final newExperience = _userExperience + amount;
    final maxExperience = 1000;

    if (newExperience >= maxExperience) {
      final updates = {
        'level': _userLevel + 1,
        'experience': 0,
        'availableAttributes': availableAttributes + 5,
        'characteristics': {
          'health': 100 + _userAttributes['endurance']! * 10,
          'mana': 50 + _userAttributes['intelligence']! * 5,
        }
      };

      setState(() {
        availableAttributes += 5;
      });

      _updateCharacterData(updates);
    } else {
      _updateCharacterData({'experience': newExperience});
    }
  }

  void _updateAttributesAndCharacteristics(String attribute) {
    if (availableAttributes > 0) {
      final newAttributes = Map<String, int>.from(_userAttributes);
      newAttributes[attribute] = (newAttributes[attribute] ?? 0) + 1;

      final updates = {
        'attributes': newAttributes,
        'availableAttributes': availableAttributes - 1,
      };

      if (attribute == 'endurance') {
        updates['characteristics.health'] = 100 + newAttributes['endurance']! * 10;
      } else if (attribute == 'intelligence') {
        updates['characteristics.mana'] = 50 + newAttributes['intelligence']! * 5;
      }

      setState(() {
        availableAttributes -= 1;
        _characterData['attributes'] = newAttributes;
        if (updates.containsKey('characteristics.health')) {
          _characterData['characteristics']!['health'] = updates['characteristics.health'];
        }
        if (updates.containsKey('characteristics.mana')) {
          _characterData['characteristics']!['mana'] = updates['characteristics.mana'];
        }
      });

      _updateCharacterData(updates);
    }
  }

  @override
  void dispose() {
    _regenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final experiencePercentage = (_userExperience / 1000) * 100;

    return Scaffold(
      body: BackgroundScreen(
        child: Column(
          children: [
            const SizedBox(height: 20),
            StatsPanel(
              characterName: _characterData['name'] ?? '',
              adena: _adena,
              currentHealth: _userCharacteristics['currentHealth'] ?? 100,
              maxHealth: _userCharacteristics['health'] ?? 100,
              level: _userLevel,
              experiencePercentage: experiencePercentage,
              currentMana: _userCharacteristics['currentMana'] ?? 50,
              maxMana: _userCharacteristics['mana'] ?? 50,
            ),
            Expanded(
              child: _selectedButton == 'сражения'
                  ? BattleTab(
                      selectedBattleType: selectedBattleType,
                      onSelectBattleType: (type) {
                        setState(() {
                          selectedBattleType = type;
                        });
                      },
                    )
                  : _selectedButton == 'персонаж'
                      ? CharacterTab(
                          userAttributes: _userAttributes,
                          userCharacteristics: _userCharacteristics,
                          availableAttributes: availableAttributes,
                          onAttributeUpdate: _updateAttributesAndCharacteristics,
                        )
                      : const settings_tab.SettingsTab(),
            ),
            BottomNav(
              selectedButton: _selectedButton,
              onSelect: (value) => setState(() => _selectedButton = value),
            ),
          ],
        ),
      ),
    );
  }
}