import 'package:flutter/material.dart';
//import 'package:lineage3/screens/game_screen.dart';


class RuleText extends StatelessWidget {
  final String title;
  final String description;

  const RuleText({ // Убираем подчеркивание и исправляем название конструктора
    required this.title,
    required this.description,
    super.key, // Добавляем key по рекомендации
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.6), // Полупрозрачный фон
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
