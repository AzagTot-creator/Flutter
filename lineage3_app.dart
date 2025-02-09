import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/character_service.dart'; // Используем ваш CharacterService

class Lineage3App extends StatelessWidget {
  final CharacterService characterService;
  final GoRouter router;

  const Lineage3App({
    super.key,
    required this.characterService,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Lineage 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
