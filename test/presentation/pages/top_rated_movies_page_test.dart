import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_state.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';

// Gunakan GenerateNiceMocks supaya semua method Cubit otomatis distub
@GenerateNiceMocks([MockSpec<TopRatedMoviesCubit>(as: #MockTopRatedMoviesCubit)])
void main() {
  late MockTopRatedMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedMoviesCubit();

    // Stub stream dan initial state supaya BlocBuilder tidak error
    when(mockCubit.stream).thenAnswer((_) => Stream<TopRatedMoviesState>.empty());
    when(mockCubit.state).thenReturn(TopRatedMoviesLoading());
  });

  tearDown(() {
    mockCubit.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (tester) async {
    when(mockCubit.state).thenReturn(TopRatedMoviesLoading());
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (tester) async {
    when(mockCubit.state).thenReturn(TopRatedMoviesHasData(<Movie>[]));
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (tester) async {
    when(mockCubit.state).thenReturn(TopRatedMoviesError('Error message'));
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display text when no data', (tester) async {
    when(mockCubit.state).thenReturn(TopRatedMoviesEmpty());
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.text('Top Rate Movie Not Found!'), findsOneWidget);
  });
}
