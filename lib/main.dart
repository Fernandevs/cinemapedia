import 'package:flutter/material.dart';

import 'package:cinemapedia/config/routes/app_routes.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().theme,
    );
  }
}