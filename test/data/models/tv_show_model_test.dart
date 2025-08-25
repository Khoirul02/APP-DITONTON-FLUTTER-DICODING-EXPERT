import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvShowModel = TvShowModel(
    backdropPath: '/path.jpg',
    firstAirDate: '2022-01-01',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'Tv Show Name',
    originalName: 'Original Tv Show Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvShow = TvShow(
    backdropPath: '/path.jpg',
    firstAirDate: '2022-01-01',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'Tv Show Name',
    originalName: 'Original Tv Show Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of TvShow entity', () async {
    final result = tTvShowModel.toEntity();
    expect(result, tTvShow);
  });
}