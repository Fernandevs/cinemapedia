import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/presentation.dart'
    show CategoriesView, CustomBottomNavigation, FavoritesView, HomeView;

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final viewRoutes = const <Widget>[
    HomeView(),
    CategoriesView(),
    FavoritesView(),
  ];

  final int index;

  const HomeScreen({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: index),
    );
  }
}
