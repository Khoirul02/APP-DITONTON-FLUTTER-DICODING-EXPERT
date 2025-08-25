import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/tv_show.dart';

abstract class PopularTvShowState extends Equatable {
  const PopularTvShowState();

  @override
  List<Object?> get props => [];
}

class PopularTvShowEmpty extends PopularTvShowState {}

class PopularTvShowLoading extends PopularTvShowState {}

class PopularTvShowError extends PopularTvShowState {
  final String message;

  const PopularTvShowError(this.message);

  @override
  List<Object?> get props => [message];
}

class PopularTvShowHasData extends PopularTvShowState {
  final List<TvShow> result;

  const PopularTvShowHasData(this.result);

  @override
  List<Object?> get props => [result];
}
