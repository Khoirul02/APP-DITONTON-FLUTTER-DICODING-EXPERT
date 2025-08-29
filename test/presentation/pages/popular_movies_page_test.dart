import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/popular_movies_state.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PopularMoviesCubit>(as: #MockPopularMoviesCubit)])
void main() {
  late MockPopularMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockPopularMoviesCubit();

    // Stub stream dan state agar BlocBuilder bisa mendengarkan
    when(mockCubit.stream).thenAnswer((_) => Stream<PopularMoviesState>.empty());
    when(mockCubit.state).thenReturn(PopularMoviesLoading());
  });

  tearDown(() {
    mockCubit.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(PopularMoviesHasData(<Movie>[]));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(PopularMoviesError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.text('Error message'), findsOneWidget);
  });
}
