import 'package:ditonton/data/models/tv_show_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/season.dart';

void main() {
  group('TvShowDetailResponse', () {
    final tEpisodeModel = EpisodeModel(
      id: 1,
      name: 'Episode 1',
      overview: 'Episode Overview',
      voteAverage: 8.0,
      voteCount: 100,
      airDate: '2025-08-28',
      episodeNumber: 1,
      episodeType: 'regular',
      productionCode: 'PC001',
      runtime: 45,
      seasonNumber: 1,
      showId: 1,
      stillPath: '/still.jpg',
    );

    final tSeasonModel = SeasonModel(
      airDate: '2025-08-28',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'Season Overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
      voteAverage: 8.5,
    );

    final tTvShowDetailResponse = TvShowDetailResponse(
      adult: false,
      backdropPath: '/backdrop.jpg',
      episodeRunTime: [45],
      firstAirDate: '2025-08-28',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: 'https://example.com',
      id: 1,
      inProduction: true,
      name: 'TV Show Name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originalName: 'Original Name',
      overview: 'Overview text',
      popularity: 9.0,
      posterPath: '/poster.jpg',
      status: 'Running',
      tagline: 'Tagline here',
      voteAverage: 8.5,
      voteCount: 100,
      lastEpisodeToAir: tEpisodeModel,
      nextEpisodeToAir: tEpisodeModel,
      seasons: [tSeasonModel],
    );

    final tTvShowDetailJson = {
      "adult": false,
      "backdrop_path": '/backdrop.jpg',
      "episode_run_time": [45],
      "first_air_date": '2025-08-28',
      "genres": [
        {"id": 1, "name": 'Action'}
      ],
      "homepage": 'https://example.com',
      "id": 1,
      "in_production": true,
      "name": 'TV Show Name',
      "number_of_episodes": 10,
      "number_of_seasons": 1,
      "original_name": 'Original Name',
      "overview": 'Overview text',
      "popularity": 9.0,
      "poster_path": '/poster.jpg',
      "status": 'Running',
      "tagline": 'Tagline here',
      "vote_average": 8.5,
      "vote_count": 100,
      "last_episode_to_air": tEpisodeModel.toJson(),
      "next_episode_to_air": tEpisodeModel.toJson(),
      "seasons": [tSeasonModel.toJson()],
    };

    final tTvShowDetailEntity = TvShowDetail(
      backdropPath: '/backdrop.jpg',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      name: 'TV Show Name',
      overview: 'Overview text',
      posterPath: '/poster.jpg',
      voteAverage: 8.5,
      voteCount: 100,
      firstAirDate: '2025-08-28',
      episodeRunTime: [45],
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      lastEpisodeToAir: Episode(
        id: 1,
        name: 'Episode 1',
        overview: 'Episode Overview',
        airDate: '2025-08-28',
        episodeNumber: 1,
        seasonNumber: 1,
        stillPath: '/still.jpg',
      ),
      nextEpisodeToAir: Episode(
        id: 1,
        name: 'Episode 1',
        overview: 'Episode Overview',
        airDate: '2025-08-28',
        episodeNumber: 1,
        seasonNumber: 1,
        stillPath: '/still.jpg',
      ),
      seasons: [
        Season(
          airDate: '2025-08-28',
          episodeCount: 10,
          id: 1,
          name: 'Season 1',
          overview: 'Season Overview',
          posterPath: '/poster.jpg',
          seasonNumber: 1,
        ),
      ],
    );

    test('should create valid TvShowDetailResponse from JSON', () {
      final result = TvShowDetailResponse.fromJson(tTvShowDetailJson);
      expect(result, tTvShowDetailResponse);
    });

    test('should convert TvShowDetailResponse to JSON', () {
      final result = tTvShowDetailResponse.toJson();
      expect(result, tTvShowDetailJson);
    });

    test('should convert TvShowDetailResponse to TvShowDetail entity', () {
      final result = tTvShowDetailResponse.toEntity();
      expect(result, tTvShowDetailEntity);
    });

    test('should support Equatable', () {
      expect(
        tTvShowDetailResponse.props,
        [
          false,
          '/backdrop.jpg',
          [45],
          '2025-08-28',
          [GenreModel(id: 1, name: 'Action')],
          'https://example.com',
          1,
          true,
          'TV Show Name',
          10,
          1,
          'Original Name',
          'Overview text',
          9.0,
          '/poster.jpg',
          'Running',
          'Tagline here',
          8.5,
          100,
          tEpisodeModel,
          tEpisodeModel,
          [tSeasonModel],
        ],
      );
    });
  });
}
