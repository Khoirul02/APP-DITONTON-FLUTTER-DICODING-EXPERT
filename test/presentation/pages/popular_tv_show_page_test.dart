import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/bloc/popular_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/popular_tv_show_state.dart';
import 'package:ditonton/presentation/pages/popular_tv_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_show_page_test.mocks.dart';

// Gunakan GenerateNiceMocks supaya stream distub otomatis
@GenerateNiceMocks([MockSpec<PopularTvShowCubit>(as: #MockPopularTvShowCubit)])
void main() {
  late MockPopularTvShowCubit mockCubit;

  setUp(() {
    mockCubit = MockPopularTvShowCubit();

    // Stub stream dan initial state
    when(mockCubit.stream).thenAnswer((_) => Stream<PopularTvShowState>.empty());
    when(mockCubit.state).thenReturn(PopularTvShowLoading());
  });

  tearDown(() {
    mockCubit.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvShowCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(PopularTvShowPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(PopularTvShowHasData(<TvShow>[]));

    await tester.pumpWidget(_makeTestableWidget(PopularTvShowPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(PopularTvShowError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvShowPage()));

    expect(find.text('Error message'), findsOneWidget);
  });
}
