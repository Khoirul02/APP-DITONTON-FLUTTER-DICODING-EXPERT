import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/episode.dart';

void main() {
  group('TvShowDetail Entity', () {
    final tEpisode = Episode(
      id: 1,
      name: 'Episode 1',
      overview: 'Episode overview',
      airDate: '2025-08-28',
      episodeNumber: 1,
      seasonNumber: 1,
      stillPath: '/still.jpg',
    );

    final tSeason = Season(
      airDate: '2025-08-28',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'Season overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
    );

    final tTvShowDetail = TvShowDetail(
      backdropPath: '/backdrop.jpg',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      overview: 'TvShow overview',
      posterPath: '/poster.jpg',
      voteAverage: 8.5,
      voteCount: 100,
      name: 'TvShow Name',
      firstAirDate: '2025-08-28',
      episodeRunTime: [50],
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      lastEpisodeToAir: tEpisode,
      nextEpisodeToAir: tEpisode,
      seasons: [tSeason],
    );

    test('should have correct properties', () {
      expect(tTvShowDetail.id, 1);
      expect(tTvShowDetail.name, 'TvShow Name');
      expect(tTvShowDetail.overview, 'TvShow overview');
      expect(tTvShowDetail.posterPath, '/poster.jpg');
      expect(tTvShowDetail.backdropPath, '/backdrop.jpg');
      expect(tTvShowDetail.voteAverage, 8.5);
      expect(tTvShowDetail.voteCount, 100);
      expect(tTvShowDetail.firstAirDate, '2025-08-28');
      expect(tTvShowDetail.episodeRunTime, [50]);
      expect(tTvShowDetail.numberOfEpisodes, 10);
      expect(tTvShowDetail.numberOfSeasons, 1);
      expect(tTvShowDetail.lastEpisodeToAir, tEpisode);
      expect(tTvShowDetail.nextEpisodeToAir, tEpisode);
      expect(tTvShowDetail.seasons, [tSeason]);
      expect(tTvShowDetail.genres.length, 1);
    });
  });
}
