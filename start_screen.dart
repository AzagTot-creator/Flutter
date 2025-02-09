import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../widgets/background_screen.dart';
import '../services/auth_service.dart';
import 'package:lineage3/services/character_service.dart';

class StartScreen extends StatefulWidget {
  final CharacterService characterService;
  const StartScreen({super.key, required this.characterService});

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  late final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(characterService: widget.characterService);
    _checkCharacter();
  }

  Future<void> _checkCharacter() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint('❌ Пользователь не авторизован! Перенаправление на /');
      if (mounted) context.go('/');  // Перенаправление на главный экран
      return;
    }

    debugPrint('🔍 Проверяем персонажа для userId: ${user.uid}');

    try {
      // Ищем персонажа по userId
      final querySnapshot = await _firestore
          .collection('characters')
          .where('userId', isEqualTo: user.uid)  // Ищем по полю userId
          .limit(1)
          .get();

      debugPrint('📊 Найдено персонажей: ${querySnapshot.docs.length}');

      if (!mounted) return;

      if (querySnapshot.docs.isNotEmpty) {
        final characterId = querySnapshot.docs.first.id;
        debugPrint('✅ Персонаж найден! ID: $characterId. Переход на /game/$characterId');
        context.go('/game/$characterId');  // Переход к игре с найденным персонажем
      } else {
        debugPrint('⚠️ Персонаж не найден. Переход на /character');
        context.go('/character');  // Перенаправление на экран создания персонажа
      }
    } catch (e) {
      debugPrint('❌ Ошибка Firestore: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при поиске персонажа: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
        child: Align(
          alignment: const Alignment(0, 0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: ElevatedButton(
                  onPressed: () => context.go('/character'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 0, 255, 0.3),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Начать игру',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  label: const Text('Войти через Google', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 0, 255, 0.3),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      debugPrint('🔑 Вход через Google...');
      await _authService.signInWithGoogle(context);
      debugPrint('✅ Авторизация успешна. Проверяем персонажа...');
      if (mounted) _checkCharacter();  // Проверка наличия персонажа после авторизации
    } catch (e) {
      debugPrint('❌ Ошибка авторизации: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка авторизации: $e')),
        );
      }
    }
  }
}
