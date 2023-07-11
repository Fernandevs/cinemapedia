import 'package:cinemapedia/domain/domain.dart' show Actor;
import 'package:cinemapedia/infrastructure/models/moviedb/cast_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'https://icon-library.com/images/no-profile-picture-icon/no-profile-picture-icon-14.jpg',
        character: cast.character,
      );
}
