import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/core/utils/enum.dart';
import 'package:move_app/movies/presentation/components/movie_horizontal_list.dart';
import 'package:move_app/movies/presentation/controller/movies_bloc.dart';
import 'package:move_app/movies/presentation/controller/movies_states.dart';

class PopularComponent extends StatelessWidget {
  const PopularComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesStates>(
      buildWhen: (previous, current) =>
      previous.popularState != current.popularState,
      builder: (context, state) {
        switch (state.popularState) {
          case RequestState.loading:
            return const MovieSectionLoading();
          case RequestState.loaded:
            return MovieHorizontalList(movies: state.popularMovies);
          case RequestState.error:
            return MovieSectionError(message: state.popularMessage);
        }
      },
    );
  }
}