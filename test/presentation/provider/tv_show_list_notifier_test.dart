import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'package:ditonton/presentation/provider/tv_show_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvShow, GetPopularTvShow, GetTopRatedTvShow])
void main() {
  late TvShowListNotifier provider;
  late MockGetNowPlayingTvShow mockGetNowPlayingTvShow;
  late MockGetPopularTvShow mockGetPopularTvShow;
  late MockGetTopRatedTvShow mockGetTopRatedTvShow;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTvShow = MockGetNowPlayingTvShow();
    mockGetPopularTvShow = MockGetPopularTvShow();
    mockGetTopRatedTvShow = MockGetTopRatedTvShow();
    provider = TvShowListNotifier(
      getNowPlayingTvShow: mockGetNowPlayingTvShow,
      getPopularTvShow: mockGetPopularTvShow,
      getTopRatedTvShow: mockGetTopRatedTvShow,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTvShow = TvShow(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Wednesday',
    overview:
        'Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.',
    popularity: 60.441,
    firstAirDate: '2022-11-23',
    posterPath: '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
    name: 'Wednesday',
    voteAverage: 8.408,
    voteCount: 9348,
  );
  final tTvShowList = <TvShow>[tTvShow];

  group('now playing tv shows', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingTvShowState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchNowPlayingTvShow();
      // assert
      verify(mockGetNowPlayingTvShow.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlayingTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchNowPlayingTvShow();
      // assert
      expect(provider.nowPlayingTvShowState, RequestState.Loading);
    });

    test('should change tv shows when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchNowPlayingTvShow();
      // assert
      expect(provider.nowPlayingTvShowState, RequestState.Loaded);
      expect(provider.nowPlayingTvShow, tTvShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingTvShow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingTvShow();
      // assert
      expect(provider.nowPlayingTvShowState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchPopularTvShow();
      // assert
      expect(provider.popularTvShowState, RequestState.Loading);
    });

    test('should change tv shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchPopularTvShow();
      // assert
      expect(provider.popularTvShowState, RequestState.Loaded);
      expect(provider.popularTvShow, tTvShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTvShow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvShow();
      // assert
      expect(provider.popularTvShowState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchTopRelateTvShow();
      // assert
      expect(provider.topRelateTvShowState, RequestState.Loading);
    });

    test('should change tv shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTvShow.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchTopRelateTvShow();
      // assert
      expect(provider.topRelateTvShowState, RequestState.Loaded);
      expect(provider.topRelateTvShow, tTvShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvShow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRelateTvShow();
      // assert
      expect(provider.topRelateTvShowState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}