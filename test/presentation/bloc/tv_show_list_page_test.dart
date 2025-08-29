import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv_show_list_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';
import 'tv_show_list_page_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTvShow,
  GetPopularTvShow,
  GetTopRatedTvShow,
])
void main() {
  late TvShowListCubit tvShowListCubit;
  late MockGetNowPlayingTvShow mockGetNowPlayingTvShow;
  late MockGetPopularTvShow mockGetPopularTvShow;
  late MockGetTopRatedTvShow mockGetTopRatedTvShow;

  setUp(() {
    mockGetNowPlayingTvShow = MockGetNowPlayingTvShow();
    mockGetPopularTvShow = MockGetPopularTvShow();
    mockGetTopRatedTvShow = MockGetTopRatedTvShow();
    tvShowListCubit = TvShowListCubit(
      getNowPlayingTvShow: mockGetNowPlayingTvShow,
      getPopularTvShow: mockGetPopularTvShow,
      getTopRatedTvShow: mockGetTopRatedTvShow,
    );
  });

  final tTvShow = testTvShow;
  final tTvShowList = <TvShow>[tTvShow];

  blocTest<TvShowListCubit, TvShowListState>(
    'Should emit [Loading, HasData] when all tv shows fetched successfully',
    build: () {
      when(mockGetNowPlayingTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      when(mockGetPopularTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      when(mockGetTopRatedTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      return tvShowListCubit;
    },
    act: (cubit) => cubit.fetchTvShows(),
    expect: () => [
      TvShowListLoading(),
      TvShowListHasData(
        nowPlaying: tTvShowList,
        popular: tTvShowList,
        topRated: tTvShowList,
      ),
    ],
    verify: (_) {
      verify(mockGetNowPlayingTvShow.execute());
      verify(mockGetPopularTvShow.execute());
      verify(mockGetTopRatedTvShow.execute());
    },
  );

  blocTest<TvShowListCubit, TvShowListState>(
    'Should emit [Loading, Error] when one of fetch fails',
    build: () {
      when(mockGetNowPlayingTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      when(mockGetPopularTvShow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTopRatedTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      return tvShowListCubit;
    },
    act: (cubit) => cubit.fetchTvShows(),
    expect: () => [
      TvShowListLoading(),
      TvShowListError("Server Failure"),
    ],
    verify: (_) {
      verify(mockGetNowPlayingTvShow.execute());
      verify(mockGetPopularTvShow.execute());
      verify(mockGetTopRatedTvShow.execute());
    },
  );
}
