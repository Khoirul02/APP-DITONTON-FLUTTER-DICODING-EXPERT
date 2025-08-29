import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_state.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/widgets/watchlist_movie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistMovieCubit extends MockCubit<WatchlistMovieState>
    implements WatchlistMovieCubit {}

class MockWatchlistTvShowCubit extends MockCubit<WatchlistTvShowState>
    implements WatchlistTvShowCubit {}

void main() {
  late MockWatchlistMovieCubit mockWatchlistMovieCubit;
  late MockWatchlistTvShowCubit mockWatchlistTvShowCubit;

  setUp(() {
    mockWatchlistMovieCubit = MockWatchlistMovieCubit();
    mockWatchlistTvShowCubit = MockWatchlistTvShowCubit();

    // supaya initState tidak error (selalu return Future<void>)
    when(() => mockWatchlistMovieCubit.fetchWatchlistMovies())
        .thenAnswer((_) async => Future.value());
    when(() => mockWatchlistTvShowCubit.fetchWatchlistTvShow())
        .thenAnswer((_) async => Future.value());
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistMovieCubit>.value(value: mockWatchlistMovieCubit),
        BlocProvider<WatchlistTvShowCubit>.value(value: mockWatchlistTvShowCubit),
      ],
      child: MaterialApp(home: body),
    );
  }

  final testTvShow = TvShow(
    backdropPath: "/path.jpg",
    firstAirDate: "2020-01-01",
    genreIds: [1, 2],
    id: 2,
    name: "Test Tv Show",
    originalName: "Test Tv Show",
    overview: "Overview tv show",
    popularity: 1.0,
    posterPath: "/poster.jpg",
    voteAverage: 8.5,
    voteCount: 200,
  );

  group('WatchlistPage Widget Test', () {
    testWidgets('should show loading indicators when state is loading',
        (tester) async {
      when(() => mockWatchlistMovieCubit.state)
          .thenReturn(WatchlistMovieLoading());
      when(() => mockWatchlistTvShowCubit.state)
          .thenReturn(WatchlistTvShowLoading());

      await tester.pumpWidget(makeTestableWidget(WatchlistPage()));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('should show tv show list when has data', (tester) async {
      when(() => mockWatchlistMovieCubit.state)
          .thenReturn(WatchlistMovieEmpty());
      when(() => mockWatchlistTvShowCubit.state)
          .thenReturn(WatchlistTvShowHasData([testTvShow]));

      await tester.pumpWidget(makeTestableWidget( WatchlistPage()));
      await tester.pump();

      expect(find.text(testTvShow.name!), findsOneWidget);
    });

     testWidgets('should show loading indicator when state is loading',
        (tester) async {
      when(() => mockWatchlistMovieCubit.state).thenReturn(WatchlistMovieLoading());

      await tester.pumpWidget(makeTestableWidget( WatchlistMovieWidget()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('should show error message when state is error',
        (tester) async {
      when(() => mockWatchlistMovieCubit.state)
          .thenReturn(const WatchlistMovieError('Failed'));

      await tester.pumpWidget(makeTestableWidget(WatchlistMovieWidget()));

      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets('should show error message when state is error',
        (tester) async {
      when(() => mockWatchlistMovieCubit.state)
          .thenReturn(const WatchlistMovieError("Failed to fetch"));
      when(() => mockWatchlistTvShowCubit.state)
          .thenReturn(const WatchlistTvShowError("Failed to fetch"));

      await tester.pumpWidget(makeTestableWidget( WatchlistPage()));

      expect(find.text("Failed to fetch"), findsWidgets);
    });
  });
}
