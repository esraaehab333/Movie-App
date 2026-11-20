import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:move_app/core/utils/app_constances.dart';
import 'package:move_app/movies/domain/entites/movie.dart';
import 'package:move_app/movies/presentation/screens/movie_detail_screen.dart';
import 'package:shimmer/shimmer.dart';

class MovieHorizontalList extends StatelessWidget {
  final List<Movie> movies;

  const MovieHorizontalList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        height: 170.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(id: movie.id),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: _MoviePoster(path: movie.backdropPath),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final String? path;

  const _MoviePoster({required this.path});

  @override
  Widget build(BuildContext context) {
    final imagePath = path;
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: 120.0,
        color: Colors.grey[850],
        child: const Icon(Icons.movie, color: Colors.white24),
      );
    }

    return CachedNetworkImage(
      width: 120.0,
      fit: BoxFit.cover,
      imageUrl: ApiConstance.imageUrl(imagePath),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[850]!,
        highlightColor: Colors.grey[800]!,
        child: Container(width: 120.0, color: Colors.black),
      ),
      errorWidget: (context, url, error) => Container(
        width: 120.0,
        color: Colors.grey[900],
        child: const Icon(Icons.broken_image, color: Colors.white24),
      ),
    );
  }
}

class MovieSectionLoading extends StatelessWidget {
  const MovieSectionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 170.0,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class MovieSectionError extends StatelessWidget {
  final String message;

  const MovieSectionError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  color: Colors.white38, size: 36.0),
              const SizedBox(height: 8.0),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}