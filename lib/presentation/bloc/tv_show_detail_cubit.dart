import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvShowDetailCubit extends Cubit<TvShowDetailState> {
  TvShowDetailCubit({
    required this.getTvShowDetail,
    required this.getTvShowRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvShowDetailEmpty());

  final GetTvShowDetail getTvShowDetail;
  final GetTvShowRecommendations getTvShowRecommendations;
  final GetWatchListStatusTvShow getWatchListStatus;
  final SaveWatchlistTvShow saveWatchlist;
  final RemoveWatchlistTvShow removeWatchlist;

  Future<void> fetchTvShowDetail(int id) async {
    emit(TvShowDetailLoading());

    final detailResult = await getTvShowDetail.execute(id);
    final recommendationResult = await getTvShowRecommendations.execute(id);
    final isAdded = await getWatchListStatus.execute(id);
    detailResult.fold(
      (failure) {
        emit(TvShowDetailError(failure.message));
      },
      (tvData) {
        recommendationResult.fold(
          (failure) {
            emit(TvShowDetailHasData(
              tvShow: tvData,
              recommendations: [],
              isAddedToWatchlist: isAdded,
            ));
          },
          (recommendations) async {
            emit(TvShowDetailHasData(
              tvShow: tvData,
              recommendations: recommendations,
              isAddedToWatchlist: isAdded,
            ));
          },
        );
      },
    );
  }

  Future<void> addWatchlist(TvShowDetail tv) async {
    final result = await saveWatchlist.execute(tv);
    final currentState = state;
    if (currentState is TvShowDetailHasData) {
      result.fold(
        (failure) {
          emit(currentState.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(currentState.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: true,
          ));
        },
      );
    }
  }

  Future<void> removeFromWatchlist(TvShowDetail tv) async {
    final result = await removeWatchlist.execute(tv);
    final currentState = state;
    if (currentState is TvShowDetailHasData) {
      result.fold(
        (failure) {
          emit(currentState.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(currentState.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: false,
          ));
        },
      );
    }
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    final currentState = state;

    if (currentState is TvShowDetailHasData) {
      emit(currentState.copyWith(isAddedToWatchlist: result));
    }
  }
}
