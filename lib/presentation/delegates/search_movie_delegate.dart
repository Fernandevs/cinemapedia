import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovies;
  final StreamController<List<Movie>> _debouncedMovies =
      StreamController.broadcast();
  final StreamController<bool> _isLoading = StreamController.broadcast();
  List<Movie> initialMovies;
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  }) : super(
          searchFieldLabel: 'Buscar películas',
          textInputAction: TextInputAction.done,
        );

  _onQueryChanged(String query) {
    _isLoading.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);

      initialMovies = movies;
      _debouncedMovies.add(movies);
      _isLoading.add(false);
    });
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: _debouncedMovies.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Movie> movies = snapshot.data ?? <Movie>[];
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieItem(
              movie: movies[index],
              onMovieSelected: (BuildContext context, Movie movie) {
                _debouncedMovies.close();
                close(context, movie);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Icon(Icons.error_outline, size: 400));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _isLoading.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data ?? false) {
              return SpinPerfect(
                duration: const Duration(seconds: 20),
                spins: 10,
                infinite: true,
                child: IconButton(
                  onPressed: () => query = '',
                  icon: const Icon(Icons.refresh_rounded),
                ),
              );
            } else if (snapshot.hasError) {
              return const Icon(Icons.error_outline);
            } else {
              return FadeIn(
                animate: query.isNotEmpty,
                child: IconButton(
                  onPressed: () => query = '',
                  icon: const Icon(Icons.clear),
                ),
              );
            }
          },
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          _debouncedMovies.close();
          close(context, null);
        },
        icon: Platform.isIOS || Platform.isMacOS
            ? const Icon(Icons.arrow_back_ios_new_rounded)
            : const Icon(Icons.arrow_back_rounded),
      );

  @override
  Widget buildResults(BuildContext context) => _buildResultsAndSuggestions();

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function(BuildContext context, Movie movie) onMovieSelected;

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            /// Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                ),
              ),
            ),
            const SizedBox(width: 10),

            /// Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(movie.title, style: textStyle.titleMedium),
                  movie.overview.length > 100
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyle.bodyMedium?.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
