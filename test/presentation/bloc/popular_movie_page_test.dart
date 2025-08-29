import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/popular_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_list_page_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesCubit popularMoviesCubit;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesCubit = PopularMoviesCubit(mockGetPopularMovies);
  });

  final tMovie = testMovie;
  final tMovieList = <Movie>[tMovie];

  blocTest<PopularMoviesCubit, PopularMoviesState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularMoviesCubit;
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesHasData(tMovieList),
    ],
    verify: (_) {
      verify(mockGetPopularMovies.execute());
    },
  );

  blocTest<PopularMoviesCubit, PopularMoviesState>(
    'Should emit [Loading, Error] when fetch data fails',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesCubit;
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetPopularMovies.execute());
    },
  );
}
