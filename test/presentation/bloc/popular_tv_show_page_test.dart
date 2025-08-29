import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'package:ditonton/presentation/bloc/popular_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/popular_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';
import 'popular_tv_show_page_test.mocks.dart';

@GenerateMocks([GetPopularTvShow])
void main() {
  late PopularTvShowCubit popularTvShowCubit;
  late MockGetPopularTvShow mockGetPopularTvShow;

  setUp(() {
    mockGetPopularTvShow = MockGetPopularTvShow();
    popularTvShowCubit = PopularTvShowCubit(mockGetPopularTvShow);
  });

  final tTvShow = testTvShow;
  final tTvShowList = <TvShow>[tTvShow];

  blocTest<PopularTvShowCubit, PopularTvShowState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetPopularTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      return popularTvShowCubit;
    },
    act: (cubit) => cubit.fetchPopularTvShow(),
    expect: () => [
      PopularTvShowLoading(),
      PopularTvShowHasData(tTvShowList),
    ],
    verify: (_) {
      verify(mockGetPopularTvShow.execute());
    },
  );

  blocTest<PopularTvShowCubit, PopularTvShowState>(
    'Should emit [Loading, Error] when fetch data fails',
    build: () {
      when(mockGetPopularTvShow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvShowCubit;
    },
    act: (cubit) => cubit.fetchPopularTvShow(),
    expect: () => [
      PopularTvShowLoading(),
      const PopularTvShowError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetPopularTvShow.execute());
    },
  );
}
