import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/movie_detail_state.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MovieDetailCubit cubit;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    cubit = MovieDetailCubit(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<MovieDetailCubit>.value(
        value: cubit,
        child: body,
      ),
    );
  }

  const tId = 1;
  final tMovies = [testMovie];

  group('MovieDetailPage Widget Test', () {
    testWidgets('should show CircularProgressIndicator when loading',
        (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);

      cubit.fetchMovieDetail(tId);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      // saat loading
      cubit.emit(MovieDetailLoading());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show movie detail when HasData state',
        (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);

      cubit.fetchMovieDetail(tId);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: tMovies,
        isAddedToWatchlist: false,
      ));
      await tester.pump();

      expect(find.text(testMovieDetail.title), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should show error message when Error state', (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Error')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testMovieList));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      cubit.emit(MovieDetailError('Error'));
      await tester.pump();

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('should add to watchlist when button pressed', (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: false,
      ));
      await tester.pump();

      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.add));
      await tester.pump();

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: true,
      ));
      await tester.pump();

      expect(find.widgetWithIcon(ElevatedButton, Icons.check), findsOneWidget);
      verify(mockSaveWatchlist.execute(testMovieDetail)).called(1);
    });

    testWidgets('should remove from watchlist when button pressed', (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => true);
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: true,
      ));
      await tester.pump();

      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.check));
      await tester.pump();

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: false,
      ));
      await tester.pump();

      expect(find.widgetWithIcon(ElevatedButton, Icons.add), findsOneWidget);
      verify(mockRemoveWatchlist.execute(testMovieDetail)).called(1);
    });

    testWidgets('should show Snackbar when added or removed from watchlist',
        (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: false,
      ));
      await tester.pump();
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.add));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    }); 

    testWidgets('should display movie recommendations when HasData state',
    (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: false,
      ));
      await tester.pump();
      expect(find.text('Recommendations'), findsOneWidget);
      expect(find.byType(InkWell), findsWidgets);
    });
    testWidgets('should show error dialog when failed to add watchlist',
        (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => false);
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: false,
      ));
      await tester.pump();

      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.add));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets('should show error dialog when failed to remove watchlist',
    (tester) async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => true);
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed remove')));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: tId)));

      cubit.emit(MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
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
