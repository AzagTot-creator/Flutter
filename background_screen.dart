// lib/widgets/background_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackgroundScreen extends StatelessWidget {
  final Widget child;

  const BackgroundScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
