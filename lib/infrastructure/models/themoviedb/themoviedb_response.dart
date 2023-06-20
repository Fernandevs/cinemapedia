import 'dart:convert';
import 'package:cinemapedia/infrastructure/models/themoviedb/movie_from_themoviedb.dart';

TheMovieDbResponse theMovieDbResponseFromJson(String str) =>
    TheMovieDbResponse.fromJson(json.decode(str));

String theMovieDbResponseToJson(TheMovieDbResponse data) =>
    json.encode(data.toJson());

class TheMovieDbResponse {
  final Dates? dates;
  final int page;
  final List<MovieFromTheMovieDB> movieFromTheMovieDBs;
  final int totalPages;
  final int totalMovieFromTheMovieDBs;

  TheMovieDbResponse({
    required this.dates,
    required this.page,
    required this.movieFromTheMovieDBs,
    required this.totalPages,
    required this.totalMovieFromTheMovieDBs,
  });

  factory TheMovieDbResponse.fromJson(Map<String, dynamic> json) =>
      TheMovieDbResponse(
        dates: json["dates"] != null ? Dates.fromJson(json["dates"]) : null,
        page: json["page"],
        movieFromTheMovieDBs: List<MovieFromTheMovieDB>.from(
          json["results"].map(
            (x) => MovieFromTheMovieDB.fromJson(x),
          ),
        ),
        totalPages: json["total_pages"],
        totalMovieFromTheMovieDBs: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "dates": dates == null ? null : dates!.toJson(),
        "page": page,
        "MovieFromTheMovieDBs":
            List<dynamic>.from(movieFromTheMovieDBs.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_MovieFromTheMovieDBs": totalMovieFromTheMovieDBs,
      };
}

class Dates {
  final DateTime maximum;
  final DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  Map<String, dynamic> toJson() => {
        "maximum":
            "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
      };
}
