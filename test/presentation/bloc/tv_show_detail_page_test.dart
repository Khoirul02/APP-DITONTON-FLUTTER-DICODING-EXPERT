import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';
import 'tv_show_detail_page_test.mocks.dart';

@GenerateMocks([
  GetTvShowDetail,
  GetTvShowRecommendations,
  GetWatchListStatusTvShow,
  SaveWatchlistTvShow,
  RemoveWatchlistTvShow,
])
void main() {
  late TvShowDetailCubit cubit;
  late MockGetTvShowDetail mockGetTvShowDetail;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;
  late MockGetWatchListStatusTvShow mockGetWatchListStatus;
  late MockSaveWatchlistTvShow mockSaveWatchlist;
  late MockRemoveWatchlistTvShow mockRemoveWatchlist;

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatusTvShow();
    mockSaveWatchlist = MockSaveWatchlistTvShow();
    mockRemoveWatchlist = MockRemoveWatchlistTvShow();

    cubit = TvShowDetailCubit(
      getTvShowDetail: mockGetTvShowDetail,
      getTvShowRecommendations: mockGetTvShowRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;
  final tTvDetail = testTvShowDetail;
  final tTvList = <TvShow>[testTvShow];

  group('Fetch TvShow Detail', () {
    blocTest<TvShowDetailCubit, TvShowDetailState>(
      'emits [Loading, HasData] when data fetched successfully',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.fetchTvShowDetail(tId),
      expect: () => [
        TvShowDetailLoading(),
        TvShowDetailHasData(
          tvShow: tTvDetail,
          recommendations: tTvList,
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<TvShowDetailCubit, TvShowDetailState>(
      'emits [Loading, Loaded with empty recommendations] when recommendations fetch fails',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Error Reco')));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.fetchTvShowDetail(tId),
      expect: () => [
        TvShowDetailLoading(),
        TvShowDetailHasData(
          tvShow: tTvDetail,
          recommendations: [],
          isAddedToWatchlist: true,
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<TvShowDetailCubit, TvShowDetailState>(
      'emits updated state when addWatchlist success',
      build: () {
        when(mockSaveWatchlist.execute(tTvDetail))
            .thenAnswer((_) async => const Right('Added'));
        return cubit;
      },
      seed: () => TvShowDetailHasData(
        tvShow: tTvDetail,
        recommendations: tTvList,
        isAddedToWatchlist: false,
      ),
      act: (cubit) => cubit.addWatchlist(tTvDetail),
      expect: () => [
        TvShowDetailHasData(
          tvShow: tTvDetail,
          recommendations: tTvList,
          isAddedToWatchlist: true,
          watchlistMessage: 'Added',
        ),
      ],
    );

    blocTest<TvShowDetailCubit, TvShowDetailState>(
      'emits updated state when removeWatchlist success',
      build: () {
        when(mockRemoveWatchlist.execute(tTvDetail))
            .thenAnswer((_) async => const Right('Removed'));
        return cubit;
      },
      seed: () => TvShowDetailHasData(
        tvShow: tTvDetail,
        recommendations: tTvList,
        isAddedToWatchlist: true,
      ),
      act: (cubit) => cubit.removeFromWatchlist(tTvDetail),
      expect: () => [
        TvShowDetailHasData(
          tvShow: tTvDetail,
          recommendations: tTvList,
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed',
        ),
      ],
    );

    blocTest<TvShowDetailCubit, TvShowDetailState>(
      'updates only watchlist status when loadWatchlistStatus is called',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return cubit;
      },
      seed: () => TvShowDetailHasData(
        tvShow: tTvDetail,
        recommendations: tTvList,
        isAddedToWatchlist: false,
      ),
      act: (cubit) => cubit.loadWatchlistStatus(tId),
      expect: () => [
        TvShowDetailHasData(
          tvShow: tTvDetail,
          recommendations: tTvList,
          isAddedToWatchlist: true,
        ),
      ],
    );
  });
}
