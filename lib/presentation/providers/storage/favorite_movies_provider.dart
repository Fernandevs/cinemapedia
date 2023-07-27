import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<StorageMovieNotifier, Map<int, Movie>>((ref) {
  final repository = ref.watch(localStorageRepositoryProvider);
  return StorageMovieNotifier(repository: repository);
});

class StorageMovieNotifier extends StateNotifier<Map<int, Movie>> {
  final LocalStorageRepository repository;
  int page = 0;

  StorageMovieNotifier({required this.repository}) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await repository.loadMovies(offset: page * 10, limit: 20);
    final aux = <int, Movie>{};
    page++;

    for (final movie in movies) {
      aux[movie.id] = movie;
    }

    state = {...state, ...aux};

    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await repository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] != null;

    if (isMovieInFavorites) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }
}
