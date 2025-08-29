import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';

void main() {
  group('SeasonModel', () {
    final tSeasonModel = SeasonModel(
      airDate: '2025-08-28',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'Season overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
      voteAverage: 8.5,
    );

    final tSeasonJson = {
      "air_date": '2025-08-28',
      "episode_count": 10,
      "id": 1,
      "name": 'Season 1',
      "overview": 'Season overview',
      "poster_path": '/poster.jpg',
      "season_number": 1,
      "vote_average": 8.5,
    };

    final tSeasonEntity = Season(
      airDate: '2025-08-28',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'Season overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
    );

    test('should be a subclass of Equatable', () {
      expect(tSeasonModel.props.isNotEmpty, true);
    });

    test('fromJson should return valid model', () {
      final result = SeasonModel.fromJson(tSeasonJson);
      expect(result, tSeasonModel);
    });

    test('toJson should return valid JSON map', () {
      final result = tSeasonModel.toJson();
      expect(result, tSeasonJson);
    });

    test('toEntity should return valid Season entity', () {
      final result = tSeasonModel.toEntity();
      expect(result, tSeasonEntity);
    });
  });
}
