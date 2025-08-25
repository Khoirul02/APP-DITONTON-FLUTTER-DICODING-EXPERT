import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';

abstract class TvShowDetailState extends Equatable {
  const TvShowDetailState();

  @override
  List<Object?> get props => [];
}

class TvShowDetailEmpty extends TvShowDetailState {}

class TvShowDetailLoading extends TvShowDetailState {}

class TvShowDetailError extends TvShowDetailState {
  final String message;
  const TvShowDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowDetailHasData extends TvShowDetailState {
  final TvShowDetail tvShow;
  final List<TvShow> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvShowDetailHasData({
    required this.tvShow,
    required this.recommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = "",
  });

  TvShowDetailHasData copyWith({
    TvShowDetail? tvShow,
    List<TvShow>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvShowDetailHasData(
      tvShow: tvShow ?? this.tvShow,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props =>
      [tvShow, recommendations, isAddedToWatchlist, watchlistMessage];
}
