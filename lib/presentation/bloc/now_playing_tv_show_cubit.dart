import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_show.dart';
import 'now_playing_tv_show_state.dart';

class NowPlayingTvShowCubit extends Cubit<NowPlayingTvShowState> {
  final GetNowPlayingTvShow getNowPlayingTvShow;

  NowPlayingTvShowCubit(this.getNowPlayingTvShow)
      : super(NowPlayingTvShowEmpty());

  Future<void> fetchNowPlayingTvShow() async {
    emit(NowPlayingTvShowLoading());

    final result = await getNowPlayingTvShow.execute();

    result.fold(
      (failure) => emit(NowPlayingTvShowError(failure.message)),
      (data) => emit(NowPlayingTvShowHasData(data)),
    );
  }
}
