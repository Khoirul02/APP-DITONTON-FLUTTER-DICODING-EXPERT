import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_state.dart';
import 'package:ditonton/presentation/widgets/watchlist_movie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistMovieCubit extends MockCubit<WatchlistMovieState>
    implements WatchlistMovieCubit {}

void main() {
  late MockWatchlistMovieCubit mockCubit;

  setUp(() {
    mockCubit = MockWatchlistMovieCubit();
  });

  Widget makeTestable(Widget body) {
    return MaterialApp(
      home: BlocProvider<WatchlistMovieCubit>.value(
        value: mockCubit,
        child: Scaffold(body: body),
      ),
    );
  }

  testWidgets('should show loading when state is WatchlistMovieLoading',
      (tester) async {
    when(() => mockCubit.state).thenReturn(WatchlistMovieLoading());

    await tester.pumpWidget(makeTestable( WatchlistMovieWidget()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show list of movies when state is WatchlistMovieHasData',
      (tester) async {
    when(() => mockCubit.state)
        .thenReturn(WatchlistMovieHasData([testMovie]));

    await tester.pumpWidget(makeTestable( WatchlistMovieWidget()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets('should show no item message when list is empty',
      (tester) async {
    when(() => mockCubit.state).thenReturn(WatchlistMovieHasData([]));

    await tester.pumpWidget(makeTestable( WatchlistMovieWidget()));

    expect(find.text('No Watchlist Item!'), findsOneWidget);
  });

  testWidgets('should show error message when state is WatchlistMovieError',
      (tester) async {
    when(() => mockCubit.state)
        .thenReturn(const WatchlistMovieError('Error Message'));

    await tester.pumpWidget(makeTestable( WatchlistMovieWidget()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error Message'), findsOneWidget);
  });
}
