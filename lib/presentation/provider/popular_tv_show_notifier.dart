import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'package:flutter/foundation.dart';

class PopularTvShowNotifier extends ChangeNotifier {
  final GetPopularTvShow getPopularTvShow;

  PopularTvShowNotifier(this.getPopularTvShow);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _tvShow = [];
  List<TvShow> get tvShow => _tvShow;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvShow() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvShow.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (TvShowData) {
        _tvShow = TvShowData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
