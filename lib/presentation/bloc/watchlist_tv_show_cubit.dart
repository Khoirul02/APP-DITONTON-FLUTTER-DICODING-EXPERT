import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show.dart';
import 'watchlist_tv_show_state.dart';

class WatchlistTvShowCubit extends Cubit<WatchlistTvShowState> {
  final GetWatchlistTvShow getWatchlistTvShow;

  WatchlistTvShowCubit(this.getWatchlistTvShow) : super(WatchlistTvShowEmpty());

  Future<void> fetchWatchlistTvShow() async {
    emit(WatchlistTvShowLoading());

    final result = await getWatchlistTvShow.execute();
    result.fold(
      (failure) {
        emit(WatchlistTvShowError(failure.message));
      },
      (tvShowData) {
        if (tvShowData.isEmpty) {
          emit(WatchlistTvShowEmpty());
        } else {
          emit(WatchlistTvShowHasData(tvShowData));
        }
      },
    );
  }
}
