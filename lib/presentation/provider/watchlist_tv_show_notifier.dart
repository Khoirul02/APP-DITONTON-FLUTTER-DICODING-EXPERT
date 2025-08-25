import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show.dart';
import 'package:flutter/foundation.dart';

class WatchlistTvShowNotifier extends ChangeNotifier {
  var _watchlistTvShow = <TvShow>[];
  List<TvShow> get watchlistTvShow => _watchlistTvShow;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTvShowNotifier({required this.getWatchlistTvShow});

  final GetWatchlistTvShow getWatchlistTvShow;

  Future<void> fetchWatchlistTvShow() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvShow.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvShow = tvShowData;
        notifyListeners();
      },
    );
  }
}
