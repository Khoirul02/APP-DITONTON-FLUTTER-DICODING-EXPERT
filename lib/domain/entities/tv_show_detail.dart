// tv_show_detail.dart
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvShowDetail extends Equatable {
  const TvShowDetail({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.name,
    required this.firstAirDate,
    required this.episodeRunTime,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    this.lastEpisodeToAir,
    this.nextEpisodeToAir,
    required this.seasons,
  });

  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final String name;
  final String firstAirDate;
  final List<int> episodeRunTime;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final Episode? lastEpisodeToAir;
  final Episode? nextEpisodeToAir;
  final List<Season> seasons;

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        id,
        overview,
        posterPath,
        voteAverage,
        voteCount,
        name,
        firstAirDate,
        episodeRunTime,
        numberOfEpisodes,
        numberOfSeasons,
        lastEpisodeToAir,
        nextEpisodeToAir,
        seasons,
      ];
}
