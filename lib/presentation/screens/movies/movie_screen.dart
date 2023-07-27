import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart'
    show
        actorsByMovieProvider,
        localStorageRepositoryProvider,
        favoriteMoviesProvider,
        movieInfoProvider;

class MovieScreen extends ConsumerStatefulWidget {
  static const String name = 'movie-screen';
  final String id;

  const MovieScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.id);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.id];

    if (movie == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isFavoriteMovie(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            // ref.watch(localStorageRepositoryProvider).toggleFavorite(movie);
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavorite.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite_rounded, color: Colors.red)
                : const Icon(Icons.favorite_border),
            error: (_, __) => throw UnimplementedError(),
          ),
        ),
      ],
      backgroundColor: Colors.black87,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress != null
                        ? const SizedBox()
                        : FadeIn(child: child),
              ),
            ),
            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
            ),
            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
            ),
            const _CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.4],
              colors: [
                Colors.black87,
                Colors.transparent,
              ],
            ),
          ],
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 10),

              /// Description
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(movie.title, style: textStyles.titleLarge),
                    Text(movie.overview),
                  ],
                ),
              )
            ],
          ),
        ),

        /// Genres
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: <Widget>[
              ...movie.genreIds.map(
                (gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(gender),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Actors
        _ActorsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 50),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final List<Actor> actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2),
                Text(
                  actor.character ?? '',
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double>? stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.colors,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
