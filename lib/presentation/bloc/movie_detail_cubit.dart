import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailEmpty());

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  Future<void> fetchMovieDetail(int id) async {
    emit(MovieDetailLoading());

    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);
    final isAdded = await getWatchListStatus.execute(id);
    detailResult.fold(
      (failure) {
        emit(MovieDetailError(failure.message));
      },
      (movie) {
        recommendationResult.fold(
          (failure) {
            emit(MovieDetailHasData(
              movie: movie,
              recommendations: const [],
              isAddedToWatchlist: isAdded,
            ));
          },
          (movies) async {
            emit(MovieDetailHasData(
              movie: movie,
              recommendations: movies,
              isAddedToWatchlist: isAdded,
            ));
          },
        );
      },
    );
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);

    result.fold(
      (failure) {
        if (state is MovieDetailHasData) {
          emit((state as MovieDetailHasData)
              .copyWith(watchlistMessage: failure.message));
        }
      },
      (successMessage) async {
        final status = await getWatchListStatus.execute(movie.id);
        if (state is MovieDetailHasData) {
          emit((state as MovieDetailHasData).copyWith(
            isAddedToWatchlist: status,
            watchlistMessage: successMessage,
          ));
        }
      },
    );
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);

    result.fold(
      (failure) {
        if (state is MovieDetailHasData) {
          emit((state as MovieDetailHasData)
              .copyWith(watchlistMessage: failure.message));
        }
      },
      (successMessage) async {
        final status = await getWatchListStatus.execute(movie.id);
        if (state is MovieDetailHasData) {
          emit((state as MovieDetailHasData).copyWith(
            isAddedToWatchlist: status,
            watchlistMessage: successMessage,
          ));
        }
      },
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final status = await getWatchListStatus.execute(id);
    if (state is MovieDetailHasData) {
      emit((state as MovieDetailHasData).copyWith(isAddedToWatchlist: status));
    }
  }
}
