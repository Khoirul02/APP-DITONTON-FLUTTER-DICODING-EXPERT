import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/tv_show.dart';

void main() {
  group('TvShow Entity', () {
    final tTvShowFull = TvShow(
      id: 1,
      name: 'TvShow Name',
      overview: 'Overview text',
      posterPath: '/poster.jpg',
      backdropPath: '/backdrop.jpg',
      firstAirDate: '2025-08-28',
      genreIds: [1, 2],
      originalName: 'Original Name',
      popularity: 10.0,
      voteAverage: 8.5,
      voteCount: 100,
    );

    final tTvShowWatchlist = TvShow.watchlist(
      id: 2,
      name: 'Watchlist TvShow',
      posterPath: '/watchlist.jpg',
      overview: 'Watchlist overview',
    );

    test('should have correct full properties', () {
      expect(tTvShowFull.id, 1);
      expect(tTvShowFull.name, 'TvShow Name');
      expect(tTvShowFull.overview, 'Overview text');
      expect(tTvShowFull.posterPath, '/poster.jpg');
      expect(tTvShowFull.backdropPath, '/backdrop.jpg');
      expect(tTvShowFull.firstAirDate, '2025-08-28');
      expect(tTvShowFull.genreIds, [1, 2]);
      expect(tTvShowFull.originalName, 'Original Name');
      expect(tTvShowFull.popularity, 10.0);
      expect(tTvShowFull.voteAverage, 8.5);
      expect(tTvShowFull.voteCount, 100);
    });

    test('should have correct watchlist properties', () {
      expect(tTvShowWatchlist.id, 2);
      expect(tTvShowWatchlist.name, 'Watchlist TvShow');
      expect(tTvShowWatchlist.overview, 'Watchlist overview');
      expect(tTvShowWatchlist.posterPath, '/watchlist.jpg');
    });
  });
}
