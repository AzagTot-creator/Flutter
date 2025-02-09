import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {
  late StorageService storageService;
  late CharacterService characterService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    storageService = StorageService(prefs);
    characterService = CharacterService();
    authService = AuthService();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Назад'),
        ),
        ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('На главную'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await _deleteCharacterAndAccount(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Удалить персонажа', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Future<void> _deleteCharacterAndAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError(context, 'Ошибка: пользователь не авторизован.');
      return;
    }

    final userId = user.uid;

    try {
      await characterService.deleteCharacter(userId);
      await storageService.deleteCharacterFromStorage();
      await authService.deleteUser(user);

      if (context.mounted) {
        context.go('/character');
      }
    } catch (error) {
      if (context.mounted) {
        _showError(context, 'Ошибка при удалении: $error');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class CharacterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteCharacter(String userId) async {
  try {
    final userDoc = _firestore.collection('characters').doc(userId);
    final docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      await userDoc.delete();
      debugPrint('Персонаж с id $userId удален');
    } else {
      throw Exception('Персонаж с ID $userId не найден в Firestore');
    }
  } catch (e) {
    debugPrint('Ошибка при удалении персонажа из Firestore: $e');
    throw Exception('Ошибка при удалении персонажа: $e');
  }
}

}

class StorageService {
  final SharedPreferences prefs;

  StorageService(this.prefs);

  Future<void> deleteCharacterFromStorage() async {
    try {
      await prefs.remove('character_data');
      debugPrint('Персонаж удален из локального хранилища');
    } catch (e) {
      debugPrint('Ошибка при удалении из хранилища: $e');
      throw Exception('Ошибка при удалении данных из локального хранилища');
    }
  }
}

class AuthService {
  Future<void> deleteUser(User user) async {
    try {
      await user.delete();
      debugPrint('Пользователь удален из Firebase Authentication');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('Повторно войдите в аккаунт и попробуйте снова.');
      } else {
        throw Exception('Ошибка при удалении аккаунта: ${e.message}');
      }
    } catch (e) {
      debugPrint('Ошибка при удалении пользователя: $e');
      throw Exception('Ошибка при удалении пользователя');
    }
  }
}
