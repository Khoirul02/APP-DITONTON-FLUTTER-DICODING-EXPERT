import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_state.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';
import 'tv_show_detail_page_test.mocks.dart';

/// HttpOverride palsu supaya test tidak bikin real HttpClient
class _FakeHttpOverrides extends HttpOverrides {}

@GenerateMocks([
  GetTvShowDetail,
  GetTvShowRecommendations,
  GetWatchListStatusTvShow,
  SaveWatchlistTvShow,
  RemoveWatchlistTvShow,
])
void main() {
  late MockGetTvShowDetail mockGetTvShowDetail;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;
  late MockGetWatchListStatusTvShow mockGetWatchListStatus;
  late MockSaveWatchlistTvShow mockSaveWatchlist;
  late MockRemoveWatchlistTvShow mockRemoveWatchlist;
  late TvShowDetailCubit cubit;

  const tId = 1;
  final tTvShows = [testTvShow];

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatusTvShow();
    mockSaveWatchlist = MockSaveWatchlistTvShow();
    mockRemoveWatchlist = MockRemoveWatchlistTvShow();

    cubit = TvShowDetailCubit(
      getTvShowDetail: mockGetTvShowDetail,
      getTvShowRecommendations: mockGetTvShowRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TvShowDetailCubit>.value(
        value: cubit,
        child: body,
      ),
    );
  }

  group('TvShowDetailPage Widget Test', () {
    testWidgets('should show CircularProgressIndicator when loading',
        (tester) async {
      when(mockGetTvShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvShowDetail));
      when(mockGetTvShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvShows));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

      cubit.emit(TvShowDetailLoading());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show tv show detail when HasData state',
        (tester) async {
      when(mockGetTvShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvShowDetail));
      when(mockGetTvShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvShows));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

      cubit.emit(TvShowDetailHasData(
        tvShow: testTvShowDetail,
        recommendations: tTvShows,
        isAddedToWatchlist: false,
      ));
      await tester.pump();

      expect(find.text(testTvShowDetail.name), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should show error message when Error state',
        (tester) async {
      when(mockGetTvShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Error')));
      when(mockGetTvShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvShows));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

      cubit.emit(TvShowDetailError('Error'));
      await tester.pump();

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('should add to watchlist when button pressed', (tester) async {
      when(mockGetTvShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvShowDetail));
      when(mockGetTvShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testTvShow]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);
      when(mockSaveWatchlist.execute(testTvShowDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));

      await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));
      cubit.emit(TvShowDetailHasData(
        tvShow: testTvShowDetail,
        recommendations: [testTvShow],
        isAddedToWatchlist: false,
      ));
      await tester.pump();

      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.add));
      await tester.pump();

      cubit.emit(TvShowDetailHasData(
        tvShow: testTvShowDetail,
        recommendations: [testTvShow],
        isAddedToWatchlist: true,
      ));
      await tester.pump();

      expect(find.widgetWithIcon(ElevatedButton, Icons.check), findsOneWidget);

      verify(mockSaveWatchlist.execute(testTvShowDetail)).called(1);
    });

    testWidgets('should remove from watchlist when button pressed', (tester) async {
      when(mockGetTvShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvShowDetail));
      when(mockGetTvShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testTvShow]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => true);
      when(mockRemoveWatchlist.execute(testTvShowDetail))
      .thenAnswer((_) async => Right('Removed from Watchlist'));

      await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

      cubit.emit(TvShowDetailHasData(
        tvShow: testTvShowDetail,
        recommendations: [testTvShow],
        isAddedToWatchlist: true,
      ));
      await tester.pump();

      expect(find.widgetWithIcon(ElevatedButton, Icons.check), findsOneWidget);

      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.check));
      await tester.pump();

      cubit.emit(TvShowDetailHasData(
        tvShow: testTvShowDetail,
        recommendations: [testTvShow],
        isAddedToWatchlist: false,
      ));
      await tester.pump();

      expect(find.widgetWithIcon(ElevatedButton, Icons.add), findsOneWidget);

      verify(mockRemoveWatchlist.execute(testTvShowDetail)).called(1);
    });

    testWidgets('should show Snackbar when added to watchlist', (tester) async {
      when(mockGetTvShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvShowDetail));
      when(mockGetTvShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testTvShow]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);
      when(mockSaveWatchlist.execute(testTvShowDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));

      await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

      cubit.emit(TvShowDetailHasData(
        tvShow: testTvShowDetail,
        recommendations: [testTvShow],
        isAddedToWatchlist: false,
      ));
      await tester.pump();

      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.add));
      await tester.pump();
      cubit.emit(TvShowDetailHasData(
        tvShow: testTvShowDetail,
        recommendations: [testTvShow],
        isAddedToWatchlist: true,
        watchlistMessage: 'Added to Watchlist',
      ));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });
      testWidgets('should show Snackbar when removed from watchlist', (tester) async {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvShowDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right([testTvShow]));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        when(mockRemoveWatchlist.execute(testTvShowDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));

        await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

        cubit.emit(TvShowDetailHasData(
          tvShow: testTvShowDetail,
          recommendations: [testTvShow],
          isAddedToWatchlist: true,
        ));
        await tester.pump();

        await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.check));
        await tester.pump();

        cubit.emit(TvShowDetailHasData(
          tvShow: testTvShowDetail,
          recommendations: [testTvShow],
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ));
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Removed from Watchlist'), findsOneWidget);
      });

      testWidgets('should display tv show recommendations', (tester) async {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvShowDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right([testTvShow]));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);

        await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

        cubit.emit(TvShowDetailHasData(
          tvShow: testTvShowDetail,
          recommendations: [testTvShow],
          isAddedToWatchlist: false,
        ));
        await tester.pump();

        expect(find.text(testTvShow.name!), findsOneWidget);
      });
      testWidgets('should show AlertDialog when failed to add watchlist', (tester) async {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvShowDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right([testTvShow]));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        when(mockSaveWatchlist.execute(testTvShowDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed add')));

        await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

        cubit.emit(TvShowDetailHasData(
          tvShow: testTvShowDetail,
          recommendations: [testTvShow],
          isAddedToWatchlist: false,
        ));
        await tester.pump();

        await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.add));
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed add'), findsOneWidget);
      });
      testWidgets('should show AlertDialog when failed to remove watchlist', (tester) async {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvShowDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right([testTvShow]));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        when(mockRemoveWatchlist.execute(testTvShowDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed remove')));

        await tester.pumpWidget(makeTestableWidget(TvShowDetailPage(id: tId)));

        cubit.emit(TvShowDetailHasData(
          tvShow: testTvShowDetail,
          recommendations: [testTvShow],
          isAddedToWatchlist: true,
        ));
        await tester.pump();

        await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.check));
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed remove'), findsOneWidget);
      });
  });
}
