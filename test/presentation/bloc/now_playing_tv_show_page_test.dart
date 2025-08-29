import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_show.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_show_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';
import 'now_playing_tv_show_page_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvShow])
void main() {
  late NowPlayingTvShowCubit nowPlayingTvShowCubit;
  late MockGetNowPlayingTvShow mockGetNowPlayingTvShow;

  setUp(() {
    mockGetNowPlayingTvShow = MockGetNowPlayingTvShow();
    nowPlayingTvShowCubit = NowPlayingTvShowCubit(mockGetNowPlayingTvShow);
  });

  final tTvShow = testTvShow;
  final tTvShowList = <TvShow>[tTvShow];

  blocTest<NowPlayingTvShowCubit, NowPlayingTvShowState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetNowPlayingTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      return nowPlayingTvShowCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingTvShow(),
    expect: () => [
      NowPlayingTvShowLoading(),
      NowPlayingTvShowHasData(tTvShowList),
    ],
    verify: (_) {
      verify(mockGetNowPlayingTvShow.execute());
    },
  );

  blocTest<NowPlayingTvShowCubit, NowPlayingTvShowState>(
    'Should emit [Loading, Error] when fetch data fails',
    build: () {
      when(mockGetNowPlayingTvShow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingTvShowCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingTvShow(),
    expect: () => [
      NowPlayingTvShowLoading(),
      NowPlayingTvShowError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetNowPlayingTvShow.execute());
    },
  );
}
