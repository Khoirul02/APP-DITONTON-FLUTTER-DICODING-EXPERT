import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/tv_show_table.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/entities/tv_show.dart';

void main() {
  group('TvShowTable', () {
    final tTvShowDetail = TvShowDetail(
      id: 1,
      name: 'TV Show Name',
      posterPath: '/poster.jpg',
      overview: 'TV Show Overview',
      genres: [],
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      firstAirDate: '2025-08-28',
      voteAverage: 8.0, backdropPath: '', voteCount: 0, episodeRunTime: [], seasons: [],
    );

    final tTvShowTable = TvShowTable(
      id: 1,
      name: 'TV Show Name',
      posterPath: '/poster.jpg',
      overview: 'TV Show Overview',
    );

    final tTvShowMap = {
      'id': 1,
      'name': 'TV Show Name',
      'posterPath': '/poster.jpg',
      'overview': 'TV Show Overview',
    };

    test('should create a valid TvShowTable from entity', () {
      final result = TvShowTable.fromEntity(tTvShowDetail);
      expect(result, tTvShowTable);
    });

    test('should create a valid TvShowTable from map', () {
      final result = TvShowTable.fromMap(tTvShowMap);
      expect(result, tTvShowTable);
    });

    test('should convert TvShowTable to JSON', () {
      final result = tTvShowTable.toJson();
      expect(result, tTvShowMap);
    });

    test('should convert TvShowTable to TvShow entity', () {
      final result = tTvShowTable.toEntity();
      expect(result, isA<TvShow>());
      expect(result.id, tTvShowTable.id);
    });

    test('should support Equatable', () {
      final result = tTvShowTable.props;
      expect(result, [1, 'TV Show Name', '/poster.jpg', 'TV Show Overview']);
    });
  });
}
