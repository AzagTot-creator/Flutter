import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lineage3/app/routes.dart'; // Импортируем файл с роутером
import 'package:lineage3/firebase_options.dart';
import 'package:lineage3/services/character_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Создание сервиса персонажа
  final CharacterService characterService = CharacterService();

  // Создание роутера
  final router = appRouter(characterService);

  // Запуск приложения
  runApp(Lineage3App(
    characterService: characterService,
    router: router,
  ));
}

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
      debugShowCheckedModeBanner: false,
      title: 'Lineage 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: router, // Используем роутер
    );
  }
}
