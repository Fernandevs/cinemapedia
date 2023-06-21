import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final popularMovies = ref.watch(popularMoviesProvider).isEmpty;
  final topRatedMovies = ref.watch(topRatedMoviesProvider).isEmpty;
  final upcomingMovies = ref.watch(upcomingMoviesProvider).isEmpty;
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider).isEmpty;

  if (popularMovies || topRatedMovies || upcomingMovies || nowPlayingMovies) {
    return true;
  }

  return false; // Termina de cargar
});
