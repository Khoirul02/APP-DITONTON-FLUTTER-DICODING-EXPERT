import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_show_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_show_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvShow])
void main() {
  late MockGetTopRatedTvShow mockGetTopRatedTvShow;
  late TopRatedTvShowNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvShow = MockGetTopRatedTvShow();
    notifier = TopRatedTvShowNotifier(getTopRatedTvShow: mockGetTopRatedTvShow)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvShow = TvShow(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    firstAirDate: 'firstAirDate',
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvShowList = <TvShow>[tTvShow];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedTvShow.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    notifier.fetchTopRatedTvShow();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv shows data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedTvShow.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    await notifier.fetchTopRatedTvShow();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvShow, tTvShowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedTvShow.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedTvShow();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}