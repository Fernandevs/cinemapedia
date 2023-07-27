import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: child),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
