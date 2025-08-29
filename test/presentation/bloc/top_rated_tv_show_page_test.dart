import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';
import 'top_rated_tv_show_page_test.mocks.dart';

@GenerateMocks([GetTopRatedTvShow])
void main() {
  late TopRatedTvShowCubit topRatedTvShowCubit;
  late MockGetTopRatedTvShow mockGetTopRatedTvShow;

  setUp(() {
    mockGetTopRatedTvShow = MockGetTopRatedTvShow();
    topRatedTvShowCubit = TopRatedTvShowCubit(mockGetTopRatedTvShow);
  });

  final tTvShowList = <TvShow>[testTvShow];

  blocTest<TopRatedTvShowCubit, TopRatedTvShowState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetTopRatedTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      return topRatedTvShowCubit;
    },
    act: (cubit) => cubit.fetchTopRatedTvShow(),
    expect: () => [
      TopRatedTvShowLoading(),
      TopRatedTvShowHasData(tTvShowList),
    ],
    verify: (_) {
      verify(mockGetTopRatedTvShow.execute());
    },
  );

  blocTest<TopRatedTvShowCubit, TopRatedTvShowState>(
    'Should emit [Loading, Error] when fetch data fails',
    build: () {
      when(mockGetTopRatedTvShow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvShowCubit;
    },
    act: (cubit) => cubit.fetchTopRatedTvShow(),
    expect: () => [
      TopRatedTvShowLoading(),
      const TopRatedTvShowError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTopRatedTvShow.execute());
    },
  );
}
