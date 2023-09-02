import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/config/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/config/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:dio/dio.dart';

class MoviedbDataSource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX'
    }
  ));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
    final movieDbResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDbResponse.results
    .where((movieDB) => movieDB.posterPath != 'no-poster')
    .map(
      (movieDB) => MovieMapper.movieDbToEntitie(movieDB)
    ).toList();

    return movies;
  }

}