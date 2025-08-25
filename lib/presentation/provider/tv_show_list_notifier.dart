import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'package:flutter/material.dart';

class TvShowListNotifier extends ChangeNotifier {
  var _nowPlayingTvShow = <TvShow>[];
  List<TvShow> get nowPlayingTvShow => _nowPlayingTvShow;

  RequestState _nowPlayingTvShowState = RequestState.Empty;
  RequestState get nowPlayingTvShowState => _nowPlayingTvShowState;

  var _popularTvShow = <TvShow>[];
  List<TvShow> get popularTvShow => _popularTvShow;

  RequestState _popularTvShowState = RequestState.Empty;
  RequestState get popularTvShowState => _popularTvShowState;

  var _topRelateTvShow = <TvShow>[];
  List<TvShow> get topRelateTvShow => _topRelateTvShow;

  RequestState _topRelateTvShowState = RequestState.Empty;
  RequestState get topRelateTvShowState => _topRelateTvShowState;

  String _message = '';
  String get message => _message;

  TvShowListNotifier({
    required this.getNowPlayingTvShow,
    required this.getPopularTvShow,
    required this.getTopRatedTvShow,
  });

  final GetNowPlayingTvShow getNowPlayingTvShow;
  final GetPopularTvShow getPopularTvShow;
  final GetTopRatedTvShow getTopRatedTvShow;

  Future<void> fetchNowPlayingTvShow() async {
    _nowPlayingTvShowState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvShow.execute();
    result.fold(
      (failure) {
        _nowPlayingTvShowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowDataPopular) {
        _nowPlayingTvShowState = RequestState.Loaded;
        _nowPlayingTvShow = tvShowDataPopular;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvShow() async {
    _popularTvShowState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvShow.execute();
    result.fold(
      (failure) {
        _popularTvShowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowDataPopular) {
        _popularTvShowState = RequestState.Loaded;
        _popularTvShow = tvShowDataPopular;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRelateTvShow() async {
    _topRelateTvShowState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvShow.execute();
    result.fold(
      (failure) {
        _topRelateTvShowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowDataTop) {
        _topRelateTvShowState = RequestState.Loaded;
        _topRelateTvShow = tvShowDataTop;
        notifyListeners();
      },
    );
  }
}
