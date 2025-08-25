import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'tv_show_list_state.dart';

class TvShowListCubit extends Cubit<TvShowListState> {
  final GetNowPlayingTvShow getNowPlayingTvShow;
  final GetPopularTvShow getPopularTvShow;
  final GetTopRatedTvShow getTopRatedTvShow;

  TvShowListCubit({
    required this.getNowPlayingTvShow,
    required this.getPopularTvShow,
    required this.getTopRatedTvShow,
  }) : super(TvShowListEmpty());

  Future<void> fetchTvShows() async {
    emit(TvShowListLoading());

    final nowPlayingResult = await getNowPlayingTvShow.execute();
    final popularResult = await getPopularTvShow.execute();
    final topRatedResult = await getTopRatedTvShow.execute();

    nowPlayingResult.fold(
      (failure) => emit(TvShowListError(failure.message)),
      (nowPlayingData) {
        popularResult.fold(
          (failure) => emit(TvShowListError(failure.message)),
          (popularData) {
            topRatedResult.fold(
              (failure) => emit(TvShowListError(failure.message)),
              (topRatedData) {
                emit(TvShowListHasData(
                  nowPlaying: nowPlayingData,
                  popular: popularData,
                  topRated: topRatedData,
                ));
              },
            );
          },
        );
      },
    );
  }
}
