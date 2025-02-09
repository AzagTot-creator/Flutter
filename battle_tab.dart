import 'package:flutter/material.dart';
import 'farm_zones/talking_island_harbor.dart';

class BattleTab extends StatelessWidget {
  final String selectedBattleType;
  final Function(String) onSelectBattleType;

  const BattleTab({
    super.key,
    required this.selectedBattleType,
    required this.onSelectBattleType,
  });
// Добавляем переменную для выпадения опыта

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Панель выбора типа сражения
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBattleButton('Фарм. Зоны'),
              _buildBattleButton('Катакомбы'),
              _buildBattleButton('Боссы'),
            ],
          ),
        ),
        
        // Контент для выбранного типа
        Expanded(
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            child: _buildBattleContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildBattleContent() {
    switch (selectedBattleType) {
      case 'Фарм. Зоны':
        return const SingleChildScrollView(
          child: TalkingIslandHarbor(),
        );
      case 'Катакомбы':
        return const Center(child: Text('Катакомбы (в разработке)'));
      case 'Боссы':
        return const Center(child: Text('Боссы (в разработке)'));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBattleButton(String label) {
    final bool isSelected = selectedBattleType == label;
    return GestureDetector(
      onTap: () => onSelectBattleType(label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 2,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}