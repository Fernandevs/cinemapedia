import 'package:flutter/material.dart';

class MovieScreen extends StatelessWidget {
  static const String name = 'movie-screen';
  final String id;

  const MovieScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MovieId: $id')),
    );
  }
}
