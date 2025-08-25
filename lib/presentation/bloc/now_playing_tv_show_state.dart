import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/tv_show.dart';

abstract class NowPlayingTvShowState extends Equatable {
  const NowPlayingTvShowState();

  @override
  List<Object?> get props => [];
}

class NowPlayingTvShowEmpty extends NowPlayingTvShowState {}

class NowPlayingTvShowLoading extends NowPlayingTvShowState {}

class NowPlayingTvShowError extends NowPlayingTvShowState {
  final String message;

  const NowPlayingTvShowError(this.message);

  @override
  List<Object?> get props => [message];
}

class NowPlayingTvShowHasData extends NowPlayingTvShowState {
  final List<TvShow> result;

  const NowPlayingTvShowHasData(this.result);

  @override
  List<Object?> get props => [result];
}
