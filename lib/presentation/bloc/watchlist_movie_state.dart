import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/movie.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object?> get props => [];
}

class WatchlistMovieEmpty extends WatchlistMovieState {}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;

  const WatchlistMovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistMovieHasData extends WatchlistMovieState {
  final List<Movie> movies;

  const WatchlistMovieHasData(this.movies);

  @override
  List<Object?> get props => [movies];
}
