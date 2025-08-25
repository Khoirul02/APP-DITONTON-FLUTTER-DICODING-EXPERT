import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'top_rated_movies_state.dart';

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesCubit(this.getTopRatedMovies) : super(TopRatedMoviesEmpty());

  Future<void> fetchTopRatedMovies() async {
    emit(TopRatedMoviesLoading());

    final result = await getTopRatedMovies.execute();

    result.fold(
      (failure) => emit(TopRatedMoviesError(failure.message)),
      (moviesData) => emit(TopRatedMoviesHasData(moviesData)),
    );
  }
}
