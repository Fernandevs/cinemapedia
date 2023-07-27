import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cinemapedia/domain/datasources/datasources.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> _database;

  IsarDatasource() {
    _database = _openDatabase();
  }

  Future<Isar> _openDatabase() async {
    final directory = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [MovieSchema],
        directory: directory.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    final isar = await _database;
    final Movie? isFavoriteMovie = await isar.movies
        .filter()
        .idEqualTo(movieId)
        .findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await _database;

    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await _database;
    final favoriteMovie = await isar.movies
        .filter()
        .idEqualTo(movie.id)
        .findFirst();

    if (favoriteMovie != null) {
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }

    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
