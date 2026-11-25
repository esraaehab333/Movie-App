import 'package:dartz/dartz.dart';
import 'package:move_app/core/error/exception.dart';
import 'package:move_app/core/error/failure.dart';
import 'package:move_app/movies/data/datasource/movie_remote_data_source.dart';
import 'package:move_app/movies/domain/entities/movie.dart';
import 'package:move_app/movies/domain/entities/movie_detail.dart';
import 'package:move_app/movies/domain/entities/recommendatoin.dart';
import 'package:move_app/movies/domain/repository/base_movies_repo.dart';
import 'package:move_app/movies/domain/usecase/get_movie_details_usecase.dart';
import 'package:move_app/movies/domain/usecase/get_recommendation_usecase.dart';

class MoviesRepository extends BaseMoviesRepo {
  final BaseMovieRemoteDataSource baseMovieRemoteDataSource;

  MoviesRepository({required this.baseMovieRemoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    try {
      final result = await baseMovieRemoteDataSource.getNowPlayingMovies();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(failure.errorMessageModel.statusMsg),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final result = await baseMovieRemoteDataSource.getPopularMovies();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(failure.errorMessageModel.statusMsg),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async {
    try {
      final result = await baseMovieRemoteDataSource.getTopRatedMovies();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(failure.errorMessageModel.statusMsg),
      );
    }
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetails(
      MovieDetailsParameters para) async {
    try {
      final result = await baseMovieRemoteDataSource.getMovieDetails(para);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(failure.errorMessageModel.statusMsg),
      );
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendation(
      RecommendationParameters parameters) async {
    try {
      final result = await baseMovieRemoteDataSource.getRecommendation(parameters);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.errorMessageModel.statusMsg,
      ));
    }
  }
}
