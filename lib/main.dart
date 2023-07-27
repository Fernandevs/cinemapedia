import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/config.dart'
    show appRouter, AppTheme, Environment;

Future<void> main() async {
  await Environment.initEnvironment();

  HttpOverrides.global = _CinemapediaHttpOverrides();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
    );
  }
}

class _CinemapediaHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) =>
            true;
}
