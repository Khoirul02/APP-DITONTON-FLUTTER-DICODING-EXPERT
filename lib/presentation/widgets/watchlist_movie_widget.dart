import 'package:ditonton/presentation/bloc/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMovieWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieCubit, WatchlistMovieState>(
        builder: (context, state) {
          if (state is WatchlistMovieLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistMovieHasData) {
            return state.movies.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return MovieCard(movie);
                    },
                    itemCount: state.movies.length,
                  )
                : Center(
                    child: Text('No Watchlist Item!'),
                  );
          } else if (state is WatchlistMovieError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Text('Data Not Found!'),
            );
          }
        },
      ),
    );
  }
}
