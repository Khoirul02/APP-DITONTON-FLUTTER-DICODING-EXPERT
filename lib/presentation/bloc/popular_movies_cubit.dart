import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesCubit(this.getPopularMovies) : super(PopularMoviesEmpty());

  Future<void> fetchPopularMovies() async {
    emit(PopularMoviesLoading());

    final result = await getPopularMovies.execute();

    result.fold(
      (failure) => emit(PopularMoviesError(failure.message)),
      (moviesData) => emit(PopularMoviesHasData(moviesData)),
    );
  }
}
