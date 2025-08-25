import 'package:ditonton/domain/usecases/search_tv_show.dart';
import 'package:ditonton/presentation/bloc/search_tv_event.dart';
import 'package:ditonton/presentation/bloc/search_tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTvShow searchTvShow;

  SearchTvBloc(this.searchTvShow) : super(SearchEmptyTv()) {
    on<OnQueryChangedTv>((event, emit) async {
      final query = event.query;

      emit(SearchLoadingTv());
      final result = await searchTvShow.execute(query);

      result.fold(
        (failure) {
          emit(SearchErrorTv(failure.message));
        },
        (data) {
          emit(SearchHasDataTv(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
