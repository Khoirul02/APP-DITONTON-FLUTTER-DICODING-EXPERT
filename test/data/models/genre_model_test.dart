import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {
  group('GenreModel', () {
    final tGenreModel = GenreModel(id: 1, name: 'Action');
    final tGenreJson = {
      'id': 1,
      'name': 'Action',
    };
    final tGenreEntity = Genre(id: 1, name: 'Action');

    test('should create valid GenreModel from JSON', () {
      final result = GenreModel.fromJson(tGenreJson);
      expect(result, tGenreModel);
    });

    test('should convert GenreModel to JSON', () {
      final result = tGenreModel.toJson();
      expect(result, tGenreJson);
    });

    test('should convert GenreModel to Genre entity', () {
      final result = tGenreModel.toEntity();
      expect(result, tGenreEntity);
    });

    test('should support Equatable', () {
      expect(tGenreModel.props, [1, 'Action']);
    });
  });
}
