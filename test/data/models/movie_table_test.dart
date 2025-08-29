import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/movie.dart';

void main() {
  group('MovieTable', () {
    final tMovieDetail = MovieDetail(
      id: 1,
      title: 'Movie Title',
      posterPath: '/poster.jpg',
      overview: 'Movie Overview',
      genres: [],
      runtime: 120,
      releaseDate: '2025-08-28',
      voteAverage: 8.5, adult: false, backdropPath: '', originalTitle: '', voteCount: 0,
    );

    final tMovieTable = MovieTable(
      id: 1,
      title: 'Movie Title',
      posterPath: '/poster.jpg',
      overview: 'Movie Overview',
    );

    final tMovieMap = {
      'id': 1,
      'title': 'Movie Title',
      'posterPath': '/poster.jpg',
      'overview': 'Movie Overview',
    };

    test('should create a valid MovieTable from entity', () {
      final result = MovieTable.fromEntity(tMovieDetail);
      expect(result, tMovieTable);
    });

    test('should create a valid MovieTable from map', () {
      final result = MovieTable.fromMap(tMovieMap);
      expect(result, tMovieTable);
    });

    test('should convert MovieTable to JSON', () {
      final result = tMovieTable.toJson();
      expect(result, tMovieMap);
    });

    test('should convert MovieTable to Movie entity', () {
      final result = tMovieTable.toEntity();
      expect(result, isA<Movie>());
      expect(result.id, tMovieTable.id);
    });

    test('should support Equatable', () {
      final result = tMovieTable.props;
      expect(result, [1, 'Movie Title', '/poster.jpg', 'Movie Overview']);
    });
  });
}
