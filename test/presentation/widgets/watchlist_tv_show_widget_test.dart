import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_state.dart';
import 'package:ditonton/presentation/widgets/watchlist_tv_show_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';

class MockWatchlistTvShowCubit extends MockCubit<WatchlistTvShowState>
    implements WatchlistTvShowCubit {}

void main() {
  late MockWatchlistTvShowCubit mockCubit;

  setUp(() {
    mockCubit = MockWatchlistTvShowCubit();
  });

  Widget makeTestable(Widget body) {
    return MaterialApp(
      home: BlocProvider<WatchlistTvShowCubit>.value(
        value: mockCubit,
        child: Scaffold(body: body),
      ),
    );
  }

  testWidgets('should show loading when state is WatchlistTvShowLoading',
      (tester) async {
    when(() => mockCubit.state).thenReturn(WatchlistTvShowLoading());

    await tester.pumpWidget(makeTestable( WatchlistTvShowWidget()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show list of tv shows when state is WatchlistTvShowHasData',
      (tester) async {
    when(() => mockCubit.state)
        .thenReturn(WatchlistTvShowHasData([testTvShow]));

    await tester.pumpWidget(makeTestable( WatchlistTvShowWidget()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Wednesday'), findsOneWidget);
  });

  testWidgets('should show no item message when list is empty',
      (tester) async {
    when(() => mockCubit.state).thenReturn(WatchlistTvShowHasData([]));

    await tester.pumpWidget(makeTestable( WatchlistTvShowWidget()));

    expect(find.text('No Watchlist Item!'), findsOneWidget);
  });

  testWidgets('should show error message when state is WatchlistTvShowError',
      (tester) async {
    when(() => mockCubit.state)
        .thenReturn(const WatchlistTvShowError('Error Message'));

    await tester.pumpWidget(makeTestable( WatchlistTvShowWidget()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error Message'), findsOneWidget);
  });
}
