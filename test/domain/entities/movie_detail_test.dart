import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {
  group('MovieDetail Entity', () {
    final tMovieDetail = MovieDetail(
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

    test('should have correct properties', () {
      expect(tMovieDetail.adult, false);
      expect(tMovieDetail.backdropPath, '/backdrop.jpg');
      expect(tMovieDetail.genres.length, 1);
      expect(tMovieDetail.id, 1);
      expect(tMovieDetail.originalTitle, 'Original Title');
      expect(tMovieDetail.overview, 'Overview text');
      expect(tMovieDetail.posterPath, '/poster.jpg');
      expect(tMovieDetail.releaseDate, '2025-08-28');
      expect(tMovieDetail.runtime, 120);
      expect(tMovieDetail.title, 'Movie Title');
      expect(tMovieDetail.voteAverage, 8.5);
      expect(tMovieDetail.voteCount, 100);
    });
  });
}
