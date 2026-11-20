import 'package:dio/dio.dart';
import 'package:move_app/movies/data/models/movie_details_model.dart';
import 'package:move_app/movies/data/models/movie_model.dart';
import 'package:move_app/movies/data/models/recommendation_model.dart';
import 'package:move_app/movies/domain/usecase/get_movie_details_usecase.dart';
import 'package:move_app/movies/domain/usecase/get_recommendation_usecase.dart';

import '../../../core/error/dio_exception.dart';
import '../../../core/utils/app_constances.dart';

abstract class BaseMovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailsModel> getMovieDetails(MovieDetailsParameters para);

  Future<List<RecommendationModel>> getRecommendation(
      RecommendationParameters parameters);
}

class MovieRemoteDataSource extends BaseMovieRemoteDataSource {
  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      final response = await Dio().get(ApiConstance.nowPlayingMoviePath);
      return List<MovieModel>.from(
        (response.data["results"] as List).map(
              (e) => MovieModel.fromJson(e),
        ),
      );
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await Dio().get(ApiConstance.popularMoviesPath);
      return List<MovieModel>.from(
        (response.data["results"] as List).map(
              (e) => MovieModel.fromJson(e),
        ),
      );
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      final response = await Dio().get(ApiConstance.topRatedMoviePath);
      return List<MovieModel>.from(
        (response.data["results"] as List).map(
              (e) => MovieModel.fromJson(e),
        ),
      );
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(MovieDetailsParameters para) async {
    try {
      final response =
      await Dio().get(ApiConstance.movieDetailsPath(para.moveId));
      return MovieDetailsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  @override
  Future<List<RecommendationModel>> getRecommendation(
      RecommendationParameters parameters) async {
    try {
      final response =
      await Dio().get(ApiConstance.recommendationPath(parameters.id));
      return List<RecommendationModel>.from(
        (response.data["results"] as List).map(
              (e) => RecommendationModel.fromJson(e),
        ),
      );
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }
}