import 'package:flutter/material.dart';
import 'package:lineage3/models/mob.dart';

class AutoBattleScreen extends StatelessWidget {
  final List<Mob> mobs;

  const AutoBattleScreen({super.key, required this.mobs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Автобой'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Битва началась!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            for (var mob in mobs)
              Text(
                'Сражение с ${mob.name} (Ур. ${mob.level})',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('Завершить бой', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
