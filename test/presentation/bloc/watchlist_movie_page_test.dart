import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_page_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieCubit watchlistMovieCubit;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieCubit = WatchlistMovieCubit(mockGetWatchlistMovies);
  });

  final tMovie = testMovie;
  final tMovieList = <Movie>[tMovie];

  blocTest<WatchlistMovieCubit, WatchlistMovieState>(
    'Should emit [Loading, HasData] when watchlist movies fetched successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return watchlistMovieCubit;
    },
    act: (cubit) => cubit.fetchWatchlistMovies(),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieHasData(tMovieList),
    ],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieCubit, WatchlistMovieState>(
    'Should emit [Loading, Empty] when watchlist movies is empty',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([]));
      return watchlistMovieCubit;
    },
    act: (cubit) => cubit.fetchWatchlistMovies(),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieEmpty(),
    ],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieCubit, WatchlistMovieState>(
    'Should emit [Loading, Error] when fetching watchlist movies fails',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistMovieCubit;
    },
    act: (cubit) => cubit.fetchWatchlistMovies(),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieError('Database Failure'),
    ],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
