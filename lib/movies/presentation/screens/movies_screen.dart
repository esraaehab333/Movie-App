import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_app/core/services/services_locator.dart';
import 'package:move_app/movies/presentation/components/now_playing_component.dart';
import 'package:move_app/movies/presentation/components/popular_component.dart';
import 'package:move_app/movies/presentation/components/top_rated_component.dart';
import 'package:move_app/movies/presentation/controller/movies_bloc.dart';
import 'package:move_app/movies/presentation/controller/movies_events.dart';

class MainMoviesScreen extends StatelessWidget {
  const MainMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoviesBloc>()
        ..add(GetNowPlayingMoviesEvent())
        ..add(GetPopularMoviesEvent())
        ..add(GetTopRatedMoviesEvent()),
      child: Scaffold(
        body: SingleChildScrollView(
          key: const Key('movieScrollView'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NowPlayingComponent(),
              _SectionHeader(
                title: 'Popular',
                onSeeMoreTap: () {
                  /// TODO : NAVIGATION TO POPULAR SCREEN
                },
              ),
              const PopularComponent(),
              _SectionHeader(
                title: 'Top Rated',
                onSeeMoreTap: () {
                  /// TODO : NAVIGATION TO Top Rated Movies Screen
                },
              ),
              const TopRatedComponent(),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeMoreTap;

  const _SectionHeader({
    required this.title,
    required this.onSeeMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 8.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onSeeMoreTap,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('See More'),
                SizedBox(width: 4.0),
                Icon(Icons.arrow_forward_ios, size: 14.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}