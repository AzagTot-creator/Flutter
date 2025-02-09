import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:lineage3/services/character_service.dart';
import 'package:go_router/go_router.dart';

final Logger _logger = Logger();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CharacterService characterService;

  AuthService({
    required this.characterService,
  });

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        final String userId = userCredential.user!.uid;
        
        // Используем новый метод из CharacterService
        final characterDoc = await characterService.getCharacterByUserId(userId);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Успешная авторизация!')),
          );
        }

        // Проверяем наличие данных персонажа
        if (characterDoc != null && characterDoc.exists) {
          final characterData = characterDoc.data() as Map<String, dynamic>;
          final characterClass = characterData['class'] as String;
          final characterName = characterData['name'] as String;
          
          if (context.mounted) {
            context.go(
              '/game/${Uri.encodeComponent(characterClass)}/${Uri.encodeComponent(characterName)}',
            );
          }
        } else {
          if (context.mounted) {
            context.go('/character');
          }
        }
      }
    } catch (error) {
      _logger.e("Ошибка авторизации: $error");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка авторизации: ${error.toString()}')),
        );
      }
    }
  }
}