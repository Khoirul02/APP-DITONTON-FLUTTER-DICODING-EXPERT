import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_movie_page_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesCubit topRatedMoviesCubit;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesCubit = TopRatedMoviesCubit(mockGetTopRatedMovies);
  });

  final tMovieList = <Movie>[testMovie];

  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedMoviesCubit;
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    expect: () => [
      TopRatedMoviesLoading(),
      TopRatedMoviesHasData(tMovieList),
    ],
    verify: (_) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    'Should emit [Loading, Error] when fetch data fails',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMoviesCubit;
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    expect: () => [
      TopRatedMoviesLoading(),
      const TopRatedMoviesError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
