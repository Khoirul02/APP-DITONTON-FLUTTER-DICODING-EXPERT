import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'top_rated_tv_show_state.dart';

class TopRatedTvShowCubit extends Cubit<TopRatedTvShowState> {
  final GetTopRatedTvShow getTopRatedTvShow;

  TopRatedTvShowCubit(this.getTopRatedTvShow) : super(TopRatedTvShowEmpty());

  Future<void> fetchTopRatedTvShow() async {
    emit(TopRatedTvShowLoading());

    final result = await getTopRatedTvShow.execute();

    result.fold(
      (failure) => emit(TopRatedTvShowError(failure.message)),
      (data) => emit(TopRatedTvShowHasData(data)),
    );
  }
}
