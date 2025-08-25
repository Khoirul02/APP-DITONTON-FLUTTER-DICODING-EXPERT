import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowListState extends Equatable {
  const TvShowListState();

  @override
  List<Object> get props => [];
}

class TvShowListEmpty extends TvShowListState {}

class TvShowListLoading extends TvShowListState {}

class TvShowListError extends TvShowListState {
  final String message;

  const TvShowListError(this.message);

  @override
  List<Object> get props => [message];
}

class TvShowListHasData extends TvShowListState {
  final List<TvShow> nowPlaying;
  final List<TvShow> popular;
  final List<TvShow> topRated;

  const TvShowListHasData({
    required this.nowPlaying,
    required this.popular,
    required this.topRated,
  });

  @override
  List<Object> get props => [nowPlaying, popular, topRated];
}
