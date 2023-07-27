import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: <GoRoute>[
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        final int index = int.parse(state.pathParameters['page'] ?? '0');

        return HomeScreen(index: index);
      },
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
      path: '/',
      redirect: (_, __) => '/home/0',
    ),
  ],
);
