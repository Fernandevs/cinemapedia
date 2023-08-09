import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos.dart';

class VideoMapper {
  static movieDBVideoToEntity(Result movieDBVideo) => Video(
        id: movieDBVideo.id,
        name: movieDBVideo.name,
        youtubeKey: movieDBVideo.key,
        publishedAt: movieDBVideo.publishedAt,
      );
}
