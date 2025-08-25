import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'package:flutter/foundation.dart';

class TopRatedTvShowNotifier extends ChangeNotifier {
  final GetTopRatedTvShow getTopRatedTvShow;

  TopRatedTvShowNotifier({required this.getTopRatedTvShow});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _tvShow = [];
  List<TvShow> get tvShow => _tvShow;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTvShow() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvShow.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvShowData) {
        _tvShow = tvShowData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
