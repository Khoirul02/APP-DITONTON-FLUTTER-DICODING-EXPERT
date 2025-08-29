import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/domain/entities/episode.dart';

void main() {
  group('EpisodeModel', () {
    final tEpisodeModel = EpisodeModel(
      id: 1,
      name: 'Pilot',
      overview: 'Episode overview',
      voteAverage: 8.5,
      voteCount: 100,
      airDate: '2025-08-28',
      episodeNumber: 1,
      episodeType: 'Standard',
      productionCode: 'PC001',
      runtime: 45,
      seasonNumber: 1,
      showId: 10,
      stillPath: '/path.jpg',
    );

    final tEpisodeJson = {
      "id": 1,
      "name": 'Pilot',
      "overview": 'Episode overview',
      "vote_average": 8.5,
      "vote_count": 100,
      "air_date": '2025-08-28',
      "episode_number": 1,
      "episode_type": 'Standard',
      "production_code": 'PC001',
      "runtime": 45,
      "season_number": 1,
      "show_id": 10,
      "still_path": '/path.jpg',
    };

    final tEpisodeEntity = Episode(
      id: 1,
      name: 'Pilot',
      overview: 'Episode overview',
      airDate: '2025-08-28',
      episodeNumber: 1,
      seasonNumber: 1,
      stillPath: '/path.jpg',
    );

    test('should be a subclass of Equatable', () {
      expect(tEpisodeModel.props.isNotEmpty, true);
    });

    test('fromJson should return a valid model', () {
      final result = EpisodeModel.fromJson(tEpisodeJson);
      expect(result, tEpisodeModel);
    });

    test('toJson should return a valid JSON map', () {
      final result = tEpisodeModel.toJson();
      expect(result, tEpisodeJson);
    });

    test('toEntity should return valid Episode entity', () {
      final result = tEpisodeModel.toEntity();
      expect(result, tEpisodeEntity);
    });
  });
}
