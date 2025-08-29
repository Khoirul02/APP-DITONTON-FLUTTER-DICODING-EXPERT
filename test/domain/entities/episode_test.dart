import 'package:ditonton/domain/entities/episode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Episode Entity', () {
    const tEpisode = Episode(
      id: 1,
      name: 'Pilot',
      overview: 'Episode overview',
      airDate: '2025-08-28',
      episodeNumber: 1,
      seasonNumber: 1,
      stillPath: '/path.jpg',
    );

    test('should create a valid Episode object', () {
      expect(tEpisode.id, 1);
      expect(tEpisode.name, 'Pilot');
      expect(tEpisode.overview, 'Episode overview');
      expect(tEpisode.airDate, '2025-08-28');
      expect(tEpisode.episodeNumber, 1);
      expect(tEpisode.seasonNumber, 1);
      expect(tEpisode.stillPath, '/path.jpg');
    });

    test('should support equality via Equatable', () {
      const tEpisode2 = Episode(
        id: 1,
        name: 'Pilot',
        overview: 'Episode overview',
        airDate: '2025-08-28',
        episodeNumber: 1,
        seasonNumber: 1,
        stillPath: '/path.jpg',
      );

      expect(tEpisode, tEpisode2);
    });
  });
}
