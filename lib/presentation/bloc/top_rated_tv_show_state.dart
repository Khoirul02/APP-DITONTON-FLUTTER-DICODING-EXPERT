import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/tv_show.dart';

abstract class TopRatedTvShowState extends Equatable {
  const TopRatedTvShowState();

  @override
  List<Object?> get props => [];
}

class TopRatedTvShowEmpty extends TopRatedTvShowState {}

class TopRatedTvShowLoading extends TopRatedTvShowState {}

class TopRatedTvShowError extends TopRatedTvShowState {
  final String message;

  const TopRatedTvShowError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopRatedTvShowHasData extends TopRatedTvShowState {
  final List<TvShow> result;

  const TopRatedTvShowHasData(this.result);

  @override
  List<Object?> get props => [result];
}
