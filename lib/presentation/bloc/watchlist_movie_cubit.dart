import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'watchlist_movie_state.dart';

class WatchlistMovieCubit extends Cubit<WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieCubit(this.getWatchlistMovies) : super(WatchlistMovieEmpty());

  Future<void> fetchWatchlistMovies() async {
    emit(WatchlistMovieLoading());

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        emit(WatchlistMovieError(failure.message));
      },
      (moviesData) {
        if (moviesData.isEmpty) {
          emit(WatchlistMovieEmpty());
        } else {
          emit(WatchlistMovieHasData(moviesData));
        }
      },
    );
  }
}
