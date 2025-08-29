import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_show_state.dart';
import 'package:ditonton/presentation/pages/now_palying_tv_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_show_page_test.mocks.dart';


/// Generate mock untuk cubit
@GenerateNiceMocks([
  MockSpec<NowPlayingTvShowCubit>(as: #MockNowPlayingTvShowCubit)
])
void main() {
  late MockNowPlayingTvShowCubit mockCubit;

  setUp(() {
    mockCubit = MockNowPlayingTvShowCubit();

    // Stub stream & state awal agar BlocBuilder tidak error
    when(mockCubit.stream)
        .thenAnswer((_) => Stream<NowPlayingTvShowState>.empty());
    when(mockCubit.state).thenReturn(NowPlayingTvShowLoading());
  });

  tearDown(() {
    mockCubit.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTvShowCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(NowPlayingTvShowLoading());

    await tester.pumpWidget(_makeTestableWidget(NowPalyingTvShowPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(NowPlayingTvShowHasData(<TvShow>[]));

    await tester.pumpWidget(_makeTestableWidget(NowPalyingTvShowPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(NowPlayingTvShowError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(NowPalyingTvShowPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display text when no data',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(NowPlayingTvShowEmpty());

    await tester.pumpWidget(_makeTestableWidget(NowPalyingTvShowPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.text('Now Playing TV Show Not Found!'), findsOneWidget);
  });
}
