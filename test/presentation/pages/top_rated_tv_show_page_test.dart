import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_show_state.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_show_page_test.mocks.dart';

// Gunakan GenerateNiceMocks supaya semua method Cubit otomatis distub
@GenerateNiceMocks([MockSpec<TopRatedTvShowCubit>(as: #MockTopRatedTvShowCubit)])
void main() {
  late MockTopRatedTvShowCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedTvShowCubit();

    // Stub stream dan initial state supaya BlocBuilder tidak error
    when(mockCubit.stream).thenAnswer((_) => Stream<TopRatedTvShowState>.empty());
    when(mockCubit.state).thenReturn(TopRatedTvShowLoading());
  });

  tearDown(() {
    mockCubit.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvShowCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (tester) async {
    when(mockCubit.state).thenReturn(TopRatedTvShowLoading());
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (tester) async {
    when(mockCubit.state).thenReturn(TopRatedTvShowHasData(<TvShow>[]));
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (tester) async {
    when(mockCubit.state).thenReturn(TopRatedTvShowError('Error message'));
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display text when no data', (tester) async {
    when(mockCubit.state).thenReturn(TopRatedTvShowEmpty());
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.text('Top Rate TV Show Not Found!'), findsOneWidget);
  });
}
