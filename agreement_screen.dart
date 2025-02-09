import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lineage3/widgets/background_screen.dart'; 
import 'package:lineage3/widgets/rule_text.dart';
import '../services/character_service.dart';

class AgreementScreen extends StatelessWidget {
  final String characterClass;
  final String characterName;
  final String characterId;
  final CharacterService characterService;

  const AgreementScreen({
    super.key,
    required this.characterClass,
    required this.characterName,
    required this.characterId,
    required this.characterService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'Пожалуйста, ознакомьтесь с правилами игры.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RuleText(
                      title: '1. Будьте порядочным игроком',
                      description:
                          'Относитесь с уважением к другим участникам игры, проявляйте доброту и справедливость. Обращайтесь с другими так, как хотели бы, чтобы они обращались с вами.',
                    ),
                    SizedBox(height: 10),
                    RuleText(
                      title: '2. Один аккаунт на игрока',
                      description:
                          'Каждый игрок может использовать только один аккаунт. На данный момент создание и управление несколькими персонажами одновременно не поддерживается.',
                    ),
                    SizedBox(height: 10),
                    RuleText(
                      title: '3. Играйте честно',
                      description:
                          'Не используйте баги, читы или другие нечестные методы для получения преимуществ в игре. Это нарушает правила честной конкуренции.',
                    ),
                    SizedBox(height: 10),
                    RuleText(
                      title: '4. Торговля внутри игры',
                      description:
                          'Обмен игровыми предметами, такими как ресурсы или экипировка, должен происходить исключительно в игре. Продажа или покупка игровых аккаунтов строго запрещена.',
                    ),
                    SizedBox(height: 10),
                    RuleText(
                      title: '5. Принятие последствий',
                      description:
                          'Я понимаю, что нарушение правил может привести к блокировке моего аккаунта.',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    backgroundColor: const Color.fromRGBO(34, 139, 34, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5.0,
                  ),
                  onPressed: () {
                    if (context.mounted) {
                      context.go('/game/$characterId');
                    }
                  },
                  child: const Text(
                    'Согласиться',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
