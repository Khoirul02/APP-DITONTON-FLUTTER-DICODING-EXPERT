import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Season Entity', () {
    const tSeason = Season(
      airDate: '2025-08-28',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'Season overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
    );

    test('should create a valid Season object', () {
      expect(tSeason.airDate, '2025-08-28');
      expect(tSeason.episodeCount, 10);
      expect(tSeason.id, 1);
      expect(tSeason.name, 'Season 1');
      expect(tSeason.overview, 'Season overview');
      expect(tSeason.posterPath, '/poster.jpg');
      expect(tSeason.seasonNumber, 1);
    });

    test('should support equality via Equatable', () {
      const tSeason2 = Season(
        airDate: '2025-08-28',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'Season overview',
        posterPath: '/poster.jpg',
        seasonNumber: 1,
      );

      expect(tSeason, tSeason2);
    });
  });
}
