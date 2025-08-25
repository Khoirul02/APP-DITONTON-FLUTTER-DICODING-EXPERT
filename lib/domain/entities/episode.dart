import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  const Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.airDate,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.stillPath,
  });

  final int id;
  final String name;
  final String overview;
  final String? airDate;
  final int episodeNumber;
  final int seasonNumber;
  final String? stillPath;

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        airDate,
        episodeNumber,
        seasonNumber,
        stillPath,
      ];
}
