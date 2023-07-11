import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/domain.dart' show MoviesRepository;
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';

// Este repositorio es inmutable
final movieRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MovieRepositoryImpl(MovieDBDatasource());
});
