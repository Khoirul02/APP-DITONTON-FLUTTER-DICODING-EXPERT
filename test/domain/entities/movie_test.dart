import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/movie.dart';

void main() {
  group('Movie Entity', () {
    final tMovieFull = Movie(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genreIds: [1, 2],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Overview text',
      popularity: 10.0,
      posterPath: '/poster.jpg',
      releaseDate: '2025-08-28',
      title: 'Movie Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 100,
    );

    final tMovieWatchlist = Movie.watchlist(
      id: 2,
      overview: 'Watchlist overview',
      posterPath: '/watchlist.jpg',
      title: 'Watchlist Movie',
    );

    test('should have correct full properties', () {
      expect(tMovieFull.id, 1);
      expect(tMovieFull.title, 'Movie Title');
      expect(tMovieFull.genreIds, [1, 2]);
    });

    test('should have correct watchlist properties', () {
      expect(tMovieWatchlist.id, 2);
      expect(tMovieWatchlist.title, 'Watchlist Movie');
      expect(tMovieWatchlist.overview, 'Watchlist overview');
      expect(tMovieWatchlist.posterPath, '/watchlist.jpg');
    });
  });
}
