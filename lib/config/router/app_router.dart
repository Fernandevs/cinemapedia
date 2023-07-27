import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/presentation.dart'
    show FavoritesView, HomeScreen, HomeView, MovieScreen;

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeView(),
          routes: <GoRoute>[
            GoRoute(
              path: 'movie/:id',
              name: MovieScreen.name,
              builder: (context, state) => MovieScreen(
                id: state.pathParameters['id'] ?? 'no-id',
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesView(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeView(),
        ),
      ],
    ),

    /// Rutas padre e hija
    // GoRoute(
    //   path: '/',
    //   name: HomeScreen.name,
    //   builder: (context, state) => const HomeScreen(child: FavoritesView()),
    //   routes: <GoRoute>[
    //     GoRoute(
    //       path: 'movie/:id',
    //       name: MovieScreen.name,
    //       builder: (context, state) => MovieScreen(
    //         id: state.pathParameters['id'] ?? 'no-id',
    //       ),
    //     ),
    //   ],
    // ),
  ],
);
