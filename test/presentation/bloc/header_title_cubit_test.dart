import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/presentation/bloc/header_title_cubit.dart';

void main() {
  group('HeaderTitleCubit', () {
    test('initial state should be "TV Show"', () {
      final cubit = HeaderTitleCubit();
      expect(cubit.state, equals('TV Show'));
    });

    test('should emit new header when changeHeaderTitle is called', () {
      final cubit = HeaderTitleCubit();

      const newTitle = 'Movies';
      cubit.changeHeaderTitle(newTitle);

      expect(cubit.state, equals(newTitle));
    });
  });
}
