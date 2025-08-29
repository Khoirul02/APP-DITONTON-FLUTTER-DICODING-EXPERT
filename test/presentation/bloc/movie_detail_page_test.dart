import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailCubit cubit;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    cubit = MovieDetailCubit(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;
  final tMovieDetail = testMovieDetail;
  final tMovies = <Movie>[testMovie];

  // --- FETCH MOVIE DETAIL ---
  blocTest<MovieDetailCubit, MovieDetailState>(
    'Should emit [Loading, HasData] when fetchMovieDetail succeeds',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(tMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return cubit;
    },
    act: (cubit) => cubit.fetchMovieDetail(tId),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
      ),
    ],
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'Should emit [Loading, Error] when fetchMovieDetail fails',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return cubit;
    },
    act: (cubit) => cubit.fetchMovieDetail(tId),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailError('Server Failure'),
    ],
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'Should emit HasData with empty recommendations when recommendations fail',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(tMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      return cubit;
    },
    act: (cubit) => cubit.fetchMovieDetail(tId),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: const [],
        isAddedToWatchlist: false,
      ),
    ],
  );

  // --- ADD WATCHLIST ---
  blocTest<MovieDetailCubit, MovieDetailState>(
    'Should update watchlist status when addWatchlist succeeds',
    build: () {
      when(mockSaveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(tMovieDetail.id))
          .thenAnswer((_) async => true);
      return cubit..emit(MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
      ));
    },
    act: (cubit) => cubit.addWatchlist(tMovieDetail),
    expect: () => [
      MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: true,
        watchlistMessage: 'Added to Watchlist',
      ),
    ],
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'Should emit HasData with watchlistMessage when addWatchlist fails',
    build: () {
      when(mockSaveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed to add')));
      return cubit..emit(MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
      ));
    },
    act: (cubit) => cubit.addWatchlist(tMovieDetail),
    expect: () => [
      MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed to add',
      ),
    ],
  );

  // --- REMOVE WATCHLIST ---
  blocTest<MovieDetailCubit, MovieDetailState>(
    'Should update watchlist status when removeFromWatchlist succeeds',
    build: () {
      when(mockRemoveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(tMovieDetail.id))
          .thenAnswer((_) async => false);
      return cubit..emit(MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: true,
      ));
    },
    act: (cubit) => cubit.removeFromWatchlist(tMovieDetail),
    expect: () => [
      MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
        watchlistMessage: 'Removed from Watchlist',
      ),
    ],
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'Should emit HasData with watchlistMessage when removeFromWatchlist fails',
    build: () {
      when(mockRemoveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed to remove')));
      return cubit..emit(MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: true,
      ));
    },
    act: (cubit) => cubit.removeFromWatchlist(tMovieDetail),
    expect: () => [
      MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: true,
        watchlistMessage: 'Failed to remove',
      ),
    ],
  );

  // --- LOAD WATCHLIST STATUS ---
  blocTest<MovieDetailCubit, MovieDetailState>(
    'Should update isAddedToWatchlist when loadWatchlistStatus called',
    build: () {
      when(mockGetWatchListStatus.execute(tMovieDetail.id))
          .thenAnswer((_) async => true);
      return cubit..emit(MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
      ));
    },
    act: (cubit) => cubit.loadWatchlistStatus(tMovieDetail.id),
    expect: () => [
      MovieDetailHasData(
        movie: tMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: true,
      ),
    ],
  );
}
