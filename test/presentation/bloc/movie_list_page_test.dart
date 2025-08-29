import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list_cubit.dart';
import 'package:ditonton/presentation/bloc/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_list_page_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
void main() {
  late MovieListCubit movieListCubit;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListCubit = MovieListCubit(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  final tMovie = testMovie;
  final tMovieList = <Movie>[tMovie];

  blocTest<MovieListCubit, MovieListState>(
    'Should emit [Loading, HasData] when all movies fetched successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return movieListCubit;
    },
    act: (cubit) => cubit.fetchMovies(),
    expect: () => [
      MovieListLoading(),
      MovieListHasData(
        nowPlaying: tMovieList,
        popular: tMovieList,
        topRated: tMovieList,
      ),
    ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetPopularMovies.execute());
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<MovieListCubit, MovieListState>(
    'Should emit [Loading, Error] when one of fetch fails',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return movieListCubit;
    },
    act: (cubit) => cubit.fetchMovies(),
    expect: () => [
      MovieListLoading(),
      MovieListError("Failed to fetch movies"),
    ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetPopularMovies.execute());
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
