import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/presentation.dart'
    show
        CustomAppbar,
        initialLoadingProvider,
        moviesSlideshowProvider,
        nowPlayingMoviesProvider,
        popularMoviesProvider,
        topRatedMoviesProvider,
        upcomingMoviesProvider,
        FullScreenLoader,
        MovieHorizontalListview,
        MoviesSlideshow;

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) {
      return const FullScreenLoader(
        messages: <String>[
          'Cargando películas',
          'Comprando palomitas de maíz',
          'Cargando populares',
          'Llamando a mi novia',
          'Ya mero...',
          'Esto está tardando más de lo esperado :(',
        ],
      );
    }

    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return CustomScrollView(slivers: [
      const SliverAppBar(
        floating: true,
        flexibleSpace: FlexibleSpaceBar(
          title: CustomAppbar(),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: <Widget>[
              MoviesSlideshow(movies: slideShowMovies),
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: 'En cines',
                subTitle: 'Lunes 20',
                loadNextPage: () =>
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
              ),
              MovieHorizontalListview(
                movies: upcomingMovies,
                title: 'Próximamente',
                subTitle: 'En este mes',
                loadNextPage: () =>
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
              ),
              MovieHorizontalListview(
                movies: popularMovies,
                title: 'Populares',
                // subTitle: '',
                loadNextPage: () =>
                    ref.read(popularMoviesProvider.notifier).loadNextPage(),
              ),
              MovieHorizontalListview(
                movies: topRatedMovies,
                title: 'Mejor calificadas',
                subTitle: 'Desde siempre',
                loadNextPage: () =>
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
              ),
              const SizedBox(height: 10),
            ],
          );
        }, childCount: 1),
      ),
    ]);
  }
}
