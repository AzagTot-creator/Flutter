import 'package:flutter/material.dart';
import 'package:lineage3/models/mob.dart';
import 'auto_battle_screen.dart';

class TalkingIslandHarbor extends StatelessWidget {
  const TalkingIslandHarbor({super.key});

  @override
  Widget build(BuildContext context) {
    List<Mob> mobs = [
      Mob(
        name: 'Волк',
        level: 5,
        maxHealth: 150,
        experience: 50,
        minDamage: 25,
        maxDamage: 35,
        imagePath: 'assets/mobs/wolf.png',
      ),
      Mob(
        name: 'Матерый Волк',
        level: 7,
        maxHealth: 220,
        experience: 75,
        minDamage: 35,
        maxDamage: 45,
        imagePath: 'assets/mobs/dire_wolf.png',
      ),
      Mob(
        name: 'Матерый Шакал',
        level: 6,
        maxHealth: 180,
        experience: 60,
        minDamage: 30,
        maxDamage: 40,
        imagePath: 'assets/mobs/jackal.png',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(178, 0, 0, 0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade800),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Talking Island Harbor',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              for (var mob in mobs) _buildMobCard(mob, context),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AutoBattleScreen(mobs: mobs),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'В бой!',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobCard(Mob mob, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 33, 33, 33),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Image.asset(mob.imagePath, width: 64, height: 64), // Используем mob.imagePath
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mob.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Уровень: ${mob.level}',
                style: TextStyle(
                  color: Colors.blue.shade300,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              _buildStatIndicator('❤️', '${mob.maxHealth}'),
              _buildStatIndicator('⚔️', '${mob.minDamage}-${mob.maxDamage}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatIndicator(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}