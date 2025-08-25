// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';

class TvShow extends Equatable {
  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.originalName,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
  });

  TvShow.watchlist({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  int id;
  String? name;
  String overview;
  String? posterPath;
  String? backdropPath;
  String? firstAirDate;
  List<int>? genreIds;
  String? originalName;
  double? popularity;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
        backdropPath,
        firstAirDate,
        genreIds,
        originalName,
        popularity,
        voteAverage,
        voteCount,
      ];
}
