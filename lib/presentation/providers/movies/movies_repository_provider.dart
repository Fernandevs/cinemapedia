import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/infrastructure/datasources/themoviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';

// Éste repositorio es inmutable
final moviesRepositoryProvider = Provider<MovieRepositoryImpl>(
  (ref) => MovieRepositoryImpl(TheMovieDBDatasource()),
);
