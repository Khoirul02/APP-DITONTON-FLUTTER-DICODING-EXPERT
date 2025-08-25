import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/search_tv_show.dart';
import 'package:ditonton/presentation/provider/tv_show_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvShow])
void main() {
  late TvShowSearchNotifier provider;
  late MockSearchTvShow mockSearchTvShow;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvShow = MockSearchTvShow();
    provider = TvShowSearchNotifier(searchTvShow: mockSearchTvShow)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTvShowModel = TvShow(
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
  final tTvShowList = <TvShow>[tTvShowModel];
  final tQuery = 'Wednesday';

  group('search tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTvShow.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchTvShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTvShow.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchTvShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tTvShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTvShow.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvShowSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}