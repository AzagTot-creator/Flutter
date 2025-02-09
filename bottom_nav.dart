// Файл: screens/game/bottom_nav.dart
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final String selectedButton;
  final Function(String) onSelect;

  const BottomNav({
    super.key,
    required this.selectedButton,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(204),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomButton(Icons.person, 'персонаж'),
          _buildBottomButton(Icons.shopping_cart, 'торговля'),
          _buildBottomButton(Icons.sports_martial_arts, 'сражения'),
          _buildBottomButton(Icons.group, 'гильдия'),
          _buildBottomButton(Icons.settings, 'настройки'),
        ],
      ),
    );
  }

  Widget _buildBottomButton(IconData icon, String label) {
    final bool isSelected = selectedButton == label;
    return GestureDetector(
      onTap: () => onSelect(label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 24,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}
