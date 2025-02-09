import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lineage3/widgets/background_screen.dart';
import 'package:lineage3/services/character_service.dart';

class CharacterSelectionScreen extends StatefulWidget {
  final CharacterService characterService;
  const CharacterSelectionScreen({super.key, required this.characterService});

  @override
  CharacterSelectionScreenState createState() =>
      CharacterSelectionScreenState();
}

class CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final TextEditingController _characterNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _characterDescription =
      'Воин: Тяжелый боец, специализируется на ближнем бою...';
  String _selectedClass = 'Воин';

  void _selectCharacterClass(String characterClass) {
    setState(() {
      _selectedClass = characterClass;
      switch (characterClass) {
        case 'Воин':
          _characterDescription =
              'Воин: Тяжелый боец, специализируется на ближнем бою. Воины владеют большими мечами, щитами и другими тяжёлыми видами оружия. Их сила — в выносливости и защите, они могут принимать на себя много урона и защищать своих союзников.';
          break;
        case 'Маг':
          _characterDescription =
              'Маг: Мастер элементальных сил и заклинаний. Маги используют свою магию для нанесения урона врагам, исцеления союзников или контроля над стихиями. Они могут вызывать огонь, лёд, молнии или использовать магические щиты для защиты.';
          break;
        case 'Лучник':
          _characterDescription =
              'Лучник: Специализируется на дальнем бою. Использует луки и стрелы для поражения врагов на большом расстоянии. Его сила — точность и скорость';
          break;
      }
    });
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    final characterName = _characterNameController.text.trim();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) context.go('/signIn');
      return;
    }

    try {
      // Проверка существования персонажа у пользователя
      final existingCharacter = await widget.characterService.getCharacterByUserId(user.uid);
      if (existingCharacter != null) {
        if (mounted) context.go('/game/${existingCharacter.id}');
        return;
      }

      // Создание нового персонажа
      final newCharacterRef = await widget.characterService.saveCharacter(user.uid, {
        'name': characterName,
        'class': _selectedClass,
        'userId': user.uid,
        'adena': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final characterId = newCharacterRef;

      if (mounted) {
        context.go('/agreement', extra: {
          'characterId': characterId,
          'characterClass': _selectedClass,
          'characterName': characterName,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSectionTitle('Введите имя персонажа:'),
                  const SizedBox(height: 20),
                  _buildNameInput(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Выберите класс персонажа:'),
                  const SizedBox(height: 20),
                  _buildClassButtons(),
                  const SizedBox(height: 20),
                  if (_characterDescription.isNotEmpty)
                    _buildClassDescription(),
                  const SizedBox(height: 20),
                  _buildCreateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: _characterNameController,
        maxLength: 15,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Введите имя персонажа';
          }
          if (value.length < 3) {
            return 'Имя должно быть не короче 3 символов';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Имя персонажа',
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildClassButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Воин', 'Маг', 'Лучник'].map((cls) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: () => _selectCharacterClass(cls),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedClass == cls
                    ? const Color.fromRGBO(0, 0, 255, 0.8)
                    : const Color.fromRGBO(0, 0, 255, 0.3),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: _selectedClass == cls ? 8 : 3,
              ),
              child: Text(
                cls,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildClassDescription() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _characterDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: _saveCharacter,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        backgroundColor: const Color.fromRGBO(0, 0, 255, 0.5),
      ),
      child: const Text(
        'Создать персонажа',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
