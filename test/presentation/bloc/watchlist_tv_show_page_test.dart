import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';
import 'watchlist_tv_show_page_test.mocks.dart';

@GenerateMocks([GetWatchlistTvShow])
void main() {
  late WatchlistTvShowCubit watchlistTvShowCubit;
  late MockGetWatchlistTvShow mockGetWatchlistTvShow;

  setUp(() {
    mockGetWatchlistTvShow = MockGetWatchlistTvShow();
    watchlistTvShowCubit = WatchlistTvShowCubit(mockGetWatchlistTvShow);
  });

  final tTvShow = testTvShow;
  final tTvShowList = <TvShow>[tTvShow];

  blocTest<WatchlistTvShowCubit, WatchlistTvShowState>(
    'Should emit [Loading, HasData] when watchlist TV shows fetched successfully',
    build: () {
      when(mockGetWatchlistTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      return watchlistTvShowCubit;
    },
    act: (cubit) => cubit.fetchWatchlistTvShow(),
    expect: () => [
      WatchlistTvShowLoading(),
      WatchlistTvShowHasData(tTvShowList),
    ],
    verify: (_) {
      verify(mockGetWatchlistTvShow.execute());
    },
  );

  blocTest<WatchlistTvShowCubit, WatchlistTvShowState>(
    'Should emit [Loading, Empty] when watchlist TV shows is empty',
    build: () {
      when(mockGetWatchlistTvShow.execute())
          .thenAnswer((_) async => Right([]));
      return watchlistTvShowCubit;
    },
    act: (cubit) => cubit.fetchWatchlistTvShow(),
    expect: () => [
      WatchlistTvShowLoading(),
      WatchlistTvShowEmpty(),
    ],
    verify: (_) {
      verify(mockGetWatchlistTvShow.execute());
    },
  );

  blocTest<WatchlistTvShowCubit, WatchlistTvShowState>(
    'Should emit [Loading, Error] when fetching watchlist TV shows fails',
    build: () {
      when(mockGetWatchlistTvShow.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistTvShowCubit;
    },
    act: (cubit) => cubit.fetchWatchlistTvShow(),
    expect: () => [
      WatchlistTvShowLoading(),
      WatchlistTvShowError('Database Failure'),
    ],
    verify: (_) {
      verify(mockGetWatchlistTvShow.execute());
    },
  );
}
