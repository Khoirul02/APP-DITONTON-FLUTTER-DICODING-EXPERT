import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {
  group('Genre Entity', () {
    final tGenre = Genre(id: 1, name: 'Action');

    test('should have correct properties', () {
      expect(tGenre.id, 1);
      expect(tGenre.name, 'Action');
      expect(tGenre.props, [1, 'Action']);
    });
  });
}
