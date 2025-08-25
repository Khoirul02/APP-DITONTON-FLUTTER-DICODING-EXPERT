import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'popular_tv_show_state.dart';

class PopularTvShowCubit extends Cubit<PopularTvShowState> {
  final GetPopularTvShow getPopularTvShow;

  PopularTvShowCubit(this.getPopularTvShow) : super(PopularTvShowEmpty());

  Future<void> fetchPopularTvShow() async {
    emit(PopularTvShowLoading());

    final result = await getPopularTvShow.execute();

    result.fold(
      (failure) => emit(PopularTvShowError(failure.message)),
      (data) => emit(PopularTvShowHasData(data)),
    );
  }
}
