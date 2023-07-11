import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async => await dotenv.load(fileName: '.env');

  static String theMovieDBKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No api key';
}
