import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListCubit({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListEmpty());

  Future<void> fetchMovies() async {
    emit(MovieListLoading());

    final nowPlayingResult = await getNowPlayingMovies.execute();
    final popularResult = await getPopularMovies.execute();
    final topRatedResult = await getTopRatedMovies.execute();

    if (nowPlayingResult.isLeft() ||
        popularResult.isLeft() ||
        topRatedResult.isLeft()) {
      emit(MovieListError("Failed to fetch movies"));
    } else {
      emit(MovieListHasData(
        nowPlaying: nowPlayingResult.getOrElse(() => []),
        popular: popularResult.getOrElse(() => []),
        topRated: topRatedResult.getOrElse(() => []),
      ));
    }
  }
}
