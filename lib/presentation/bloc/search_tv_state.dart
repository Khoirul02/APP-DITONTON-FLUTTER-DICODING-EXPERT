import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

abstract class SearchTvState extends Equatable {
  const SearchTvState();

  @override
  List<Object> get props => [];
}

class SearchEmptyTv extends SearchTvState {}

class SearchLoadingTv extends SearchTvState {}

class SearchErrorTv extends SearchTvState {
  final String message;

  SearchErrorTv(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasDataTv extends SearchTvState {
  final List<TvShow> result;

  SearchHasDataTv(this.result);

  @override
  List<Object> get props => [result];
}
