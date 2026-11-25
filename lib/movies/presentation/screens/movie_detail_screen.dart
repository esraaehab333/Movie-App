import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_app/core/services/services_locator.dart';
import 'package:move_app/core/utils/app_constances.dart';
import 'package:move_app/core/utils/enum.dart';
import 'package:move_app/movies/domain/entities/movie_detail.dart';
import 'package:move_app/movies/presentation/controller/movie_details_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailScreen extends StatelessWidget {
  final int id;

  const MovieDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MovieDetailsBloc>()
        ..add(GetMovieDetailsEvent(id: id))
        ..add(GetMovieRecommendationEvent(id: id)),
      lazy: false,
      child: const Scaffold(
        body: MovieDetailContent(),
      ),
    );
  }
}

class MovieDetailContent extends StatelessWidget {
  const MovieDetailContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        switch (state.movieDetailsState) {
          case RequestState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case RequestState.loaded:
            final details = state.movieDetails!;
            return CustomScrollView(
              key: const Key('movieDetailScrollView'),
              slivers: [
                _DetailsAppBar(backdropPath: details.backdropPath),
                SliverToBoxAdapter(
                  child: FadeInUp(
                    from: 20,
                    duration: const Duration(milliseconds: 500),
                    child: _DetailsInfo(details: details),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: _SectionTitle(title: 'More like this'),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
                  sliver: _showRecommendations(),
                ),
              ],
            );
          case RequestState.error:
            return Center(child: Text(state.message));
        }
      },
    );
  }

  Widget _showRecommendations() {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final recommendation = state.recommendation[index];
              final path = recommendation.backdropPath;
              return FadeInUp(
                from: 20,
                duration: const Duration(milliseconds: 500),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: (path == null || path.isEmpty)
                      ? Container(
                    color: Colors.grey[850],
                    child: const Center(
                      child: Icon(Icons.movie, color: Colors.white24),
                    ),
                  )
                      : CachedNetworkImage(
                    imageUrl: ApiConstance.imageUrl(path),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[850]!,
                      highlightColor: Colors.grey[800]!,
                      child: Container(color: Colors.black),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            childCount: state.recommendation.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 0.7,
            crossAxisCount: 3,
          ),
        );
      },
    );
  }
}

class _DetailsAppBar extends StatelessWidget {
  final String? backdropPath;

  const _DetailsAppBar({required this.backdropPath});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 280.0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: FadeIn(
          duration: const Duration(milliseconds: 500),
          child: ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.black,
                  Colors.transparent,
                ],
                stops: [0.0, 0.6, 1.0],
              ).createShader(
                Rect.fromLTRB(0.0, 0.0, rect.width, rect.height),
              );
            },
            blendMode: BlendMode.dstIn,
            child: _buildBackdrop(
              backdropPath,
              MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackdrop(String? path, double width) {
    if (path == null || path.isEmpty) {
      return Container(
        width: width,
        color: Colors.grey[900],
        child: const Icon(Icons.movie, size: 64.0, color: Colors.white24),
      );
    }
    return CachedNetworkImage(
      width: width,
      imageUrl: ApiConstance.imageUrl(path),
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[900],
        child: const Icon(Icons.error),
      ),
    );
  }
}

class _DetailsInfo extends StatelessWidget {
  final MovieDetail details;

  const _DetailsInfo({required this.details});

  @override
  Widget build(BuildContext context) {
    final year =
    details.releaseDate.isEmpty ? '' : details.releaseDate.split('-')[0];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            details.title,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (year.isNotEmpty)
                _InfoPill(
                  child: Text(
                    year,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              _InfoPill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 18.0),
                    const SizedBox(width: 4.0),
                    Text(
                      '${details.voteAverage.toStringAsFixed(1)}/10',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (details.runtime > 0)
                _InfoPill(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule,
                          color: Colors.white70, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(
                        _showDuration(details.runtime),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (details.genres.isNotEmpty) ...[
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: details.genres
                  .map(
                    (genre) => Chip(
                  label: Text(
                    genre.name,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                  backgroundColor: Colors.white10,
                ),
              )
                  .toList(),
            ),
          ],
          const SizedBox(height: 24.0),
          const _SectionTitle(title: 'Overview'),
          const SizedBox(height: 12.0),
          Text(
            details.overview.isEmpty
                ? 'No overview available.'
                : details.overview,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _InfoPill extends StatelessWidget {
  final Widget child;

  const _InfoPill({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 4.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}