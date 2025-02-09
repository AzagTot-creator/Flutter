import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:lineage3/screens/game/game_screen.dart';
import '../services/character_service.dart';
import '../screens/start_screen.dart';
import '../screens/character_selection_screen.dart';
import '../screens/agreement_screen.dart';



class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ошибка')),
      body: const Center(child: Text('Произошла ошибка!')),
    );
  }
}


GoRouter appRouter(CharacterService characterService) => GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return StartScreen(characterService: characterService);
          },
        ),
        GoRoute(
          path: '/character',
          builder: (BuildContext context, GoRouterState state) {
            return CharacterSelectionScreen(characterService: characterService);
          },
        ),
        GoRoute(
          path: '/agreement',
          builder: (BuildContext context, GoRouterState state) {
            final params = state.extra as Map<String, dynamic>;
            return AgreementScreen(
              characterClass: params['characterClass'] as String,
              characterName: params['characterName'] as String,
              characterId: params['characterId'],
              characterService: characterService,
            );
          },
        ),
        GoRoute(
  path: '/game/:characterId',
  builder: (context, state) {
    final characterId = state.pathParameters['characterId'];
    if (characterId == null) {
      return const ErrorScreen(); // Замените на существующий экран
    }
    return GameScreen(
      characterId: characterId,
      characterService: characterService,
    );
  },
)
      ],
    );