import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final nowPLayingMovies = ref.watch(nowPlayingMoviesProvider);

  if(nowPLayingMovies.isEmpty) return [];

  return nowPLayingMovies.sublist(0, 6);
});
