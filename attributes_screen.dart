import 'package:flutter/material.dart';
import 'package:lineage3/widgets/stat_widget.dart';

class AttributesScreen extends StatelessWidget {
  final Map<String, int> userAttributes;
  final Map<String, int> userCharacteristics;
  final int availableAttributes;
  final Function(String) onAttributeUpdate;

  const AttributesScreen({
    super.key,
    required this.userAttributes,
    required this.userCharacteristics,
    required this.availableAttributes,
    required this.onAttributeUpdate,
  });

  // Метод для безопасного получения значений из Map
  int _getAttributeValue(Map<String, int> map, String key) {
    return map[key] ?? 0; // Если значение отсутствует, возвращается 0
  }

  // Метод для форматирования процентных значений
  String _formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  // Создание строки с информацией об атрибуте
  Widget _buildAttributeRow(
    String label,
    String description,
    int value,
    VoidCallback onIncrement,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatWidget(
          label: label,
          value: description,
          count: value,
          // Если доступны очки, кнопка активна, иначе отключена (null)
          onIncrement: availableAttributes > 0 ? onIncrement : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final strength = _getAttributeValue(userAttributes, 'strength');
    final agility = _getAttributeValue(userAttributes, 'agility');
    final intelligence = _getAttributeValue(userAttributes, 'intelligence');
    final endurance = _getAttributeValue(userAttributes, 'endurance');
    final luck = _getAttributeValue(userAttributes, 'luck');

    final health = _getAttributeValue(userCharacteristics, 'health');
    final mana = _getAttributeValue(userCharacteristics, 'mana');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок панели и отображение доступных очков
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Атрибуты персонажа',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Chip(
                backgroundColor: availableAttributes > 0 
                    ? Colors.blue[800]
                    : Colors.grey[800],
                label: Text(
                  'Очков: $availableAttributes',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Сила
          _buildAttributeRow(
            '💪 Сила',
            'Физ. урон: $strength',
            strength,
            () => onAttributeUpdate('strength'),
          ),
          // Ловкость
          _buildAttributeRow(
            '🎯 Ловкость',
            'Уклонение: ${_formatPercentage(agility * 0.5)}\n'
            'Меткость: ${_formatPercentage(agility * 0.7)}',
            agility,
            () => onAttributeUpdate('agility'),
          ),
          // Интеллект
          _buildAttributeRow(
            '🧠 Интеллект',
            'Маг. урон: $intelligence\n'
            'Мана: $mana',
            intelligence,
            () => onAttributeUpdate('intelligence'),
          ),
          // Выносливость
          _buildAttributeRow(
            '🛡️ Выносливость',
            'Здоровье: $health',
            endurance,
            () => onAttributeUpdate('endurance'),
          ),
          // Удача
          _buildAttributeRow(
            '🍀 Удача',
            'Крит: ${_formatPercentage(luck * 0.5)}\n'
            'Множитель: ${(1.5 + luck * 0.05).toStringAsFixed(2)}x',
            luck,
            () => onAttributeUpdate('luck'),
          ),
        ],
      ),
    );
  }
}
