import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {
  group('MovieDetailResponse', () {
    final tMovieDetailResponse = MovieDetailResponse(
      adult: false,
      backdropPath: '/backdrop.jpg',
      budget: 100000,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: 'https://example.com',
      id: 1,
      imdbId: 'tt1234567',
      originalLanguage: 'en',
      originalTitle: 'Original Title',
      overview: 'Overview text',
      popularity: 9.0,
      posterPath: '/poster.jpg',
      releaseDate: '2025-08-28',
      revenue: 200000,
      runtime: 120,
      status: 'Released',
      tagline: 'Tagline here',
      title: 'Movie Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 100,
    );

    final tMovieDetailJson = {
      "adult": false,
      "backdrop_path": '/backdrop.jpg',
      "budget": 100000,
      "genres": [
        {"id": 1, "name": 'Action'}
      ],
      "homepage": 'https://example.com',
      "id": 1,
      "imdb_id": 'tt1234567',
      "original_language": 'en',
      "original_title": 'Original Title',
      "overview": 'Overview text',
      "popularity": 9.0,
      "poster_path": '/poster.jpg',
      "release_date": '2025-08-28',
      "revenue": 200000,
      "runtime": 120,
      "status": 'Released',
      "tagline": 'Tagline here',
      "title": 'Movie Title',
      "video": false,
      "vote_average": 8.5,
      "vote_count": 100,
    };

    final tMovieDetailEntity = MovieDetail(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Overview text',
      posterPath: '/poster.jpg',
      releaseDate: '2025-08-28',
      runtime: 120,
      title: 'Movie Title',
      voteAverage: 8.5,
      voteCount: 100,
    );

    test('should create valid MovieDetailResponse from JSON', () {
      final result = MovieDetailResponse.fromJson(tMovieDetailJson);
      expect(result, tMovieDetailResponse);
    });

    test('should convert MovieDetailResponse to JSON', () {
      final result = tMovieDetailResponse.toJson();
      expect(result, tMovieDetailJson);
    });

    test('should convert MovieDetailResponse to MovieDetail entity', () {
      final result = tMovieDetailResponse.toEntity();
      expect(result, tMovieDetailEntity);
    });

    test('should support Equatable', () {
      expect(
        tMovieDetailResponse.props,
        [
          false,
          '/backdrop.jpg',
          100000,
          [GenreModel(id: 1, name: 'Action')],
          'https://example.com',
          1,
          'tt1234567',
          'en',
          'Original Title',
          'Overview text',
          9.0,
          '/poster.jpg',
          '2025-08-28',
          200000,
          120,
          'Released',
          'Tagline here',
          'Movie Title',
          false,
          8.5,
          100
        ],
      );
    });
  });
}
