import 'package:flutter/material.dart';
import 'attributes_screen.dart';

class CharacterTab extends StatefulWidget {
  final Map<String, int> userAttributes;
  final Map<String, int> userCharacteristics;
  final int availableAttributes;
  final Function(String) onAttributeUpdate;

  const CharacterTab({
    super.key,
    required this.userAttributes,
    required this.userCharacteristics,
    required this.availableAttributes,
    required this.onAttributeUpdate,
  });

  @override
  CharacterTabState createState() => CharacterTabState();
}

class CharacterTabState extends State<CharacterTab> {
  String _selectedCharacterTab = 'атрибуты';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Панель с кнопками вкладок (Атрибуты, Снаряжение, Навыки)
        Container(
          color: const Color.fromARGB(200, 0, 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCharacterTabButton('атрибуты'),
              _buildCharacterTabButton('снаряжение'),
              _buildCharacterTabButton('навыки'),
            ],
          ),
        ),
        // Контент выбранной вкладки
        Expanded(
          child: Container(
            color: const Color.fromARGB(200, 0, 0, 0),
            child: _buildCharacterTabContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterTabButton(String label) {
    final bool isSelected = _selectedCharacterTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCharacterTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label[0].toUpperCase() + label.substring(1),
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterTabContent() {
    switch (_selectedCharacterTab) {
      case 'атрибуты':
        return AttributesScreen(
          userAttributes: widget.userAttributes,
          userCharacteristics: widget.userCharacteristics,
          availableAttributes: widget.availableAttributes,
          onAttributeUpdate: widget.onAttributeUpdate,
        );
      default:
        return Center(
          child: Text(
            '$_selectedCharacterTab (в разработке)',
            style: const TextStyle(color: Colors.white),
          ),
        );
    }
  }
}
