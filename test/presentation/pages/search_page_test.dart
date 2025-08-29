import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_show.dart';
import 'package:ditonton/presentation/bloc/header_title_cubit.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/search_event.dart';
import 'package:ditonton/presentation/bloc/search_state.dart';
import 'package:ditonton/presentation/bloc/search_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/search_tv_event.dart';
import 'package:ditonton/presentation/bloc/search_tv_state.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_page_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTvShow])
void main() {
  late MockSearchMovies mockSearchMovies;
  late MockSearchTvShow mockSearchTvShows;
  late SearchBloc searchBloc;
  late SearchTvBloc searchTvBloc;
  late HeaderTitleCubit headerTitleCubit;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTvShows = MockSearchTvShow();
    searchBloc = SearchBloc(mockSearchMovies);
    searchTvBloc = SearchTvBloc(mockSearchTvShows);
    headerTitleCubit = HeaderTitleCubit();
  });

  tearDown(() {
    searchBloc.close();
    searchTvBloc.close();
    headerTitleCubit.close();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>.value(value: searchBloc),
        BlocProvider<SearchTvBloc>.value(value: searchTvBloc),
        BlocProvider<HeaderTitleCubit>.value(value: headerTitleCubit),
      ],
      child: MaterialApp(home: body),
    );
  }

  const tQuery = 'spiderman';
  final tMovie = Movie(
    adult: false,
    backdropPath: "/path.jpg",
    genreIds: [14, 28],
    id: 1,
    originalTitle: "Spiderman",
    overview: "overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    releaseDate: "2021-05-05",
    title: "Spiderman",
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTv = TvShow(
    backdropPath: "/path.jpg",
    genreIds: [18, 10765],
    id: 1,
    name: "Loki",
    originalName: "Loki",
    overview: "overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    voteAverage: 8.0,
    voteCount: 100,
    firstAirDate: "2021-06-09",
  );

  group('SearchPage Movies', () {
    testWidgets('should show CircularProgressIndicator when loading',
        (tester) async {
      headerTitleCubit.emit('Movies');
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right([tMovie]));

      searchBloc.add(OnQueryChanged(tQuery));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      searchBloc.emit(SearchLoading());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show MovieCard when data loaded', (tester) async {
      headerTitleCubit.emit('Movies');
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right([tMovie]));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      searchBloc.emit(SearchHasData([tMovie]));
      await tester.pump();

      expect(find.text('Spiderman'), findsOneWidget);
    });

    testWidgets('should show error message when Error state', (tester) async {
      headerTitleCubit.emit('Movies');
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Error')));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      searchBloc.emit(SearchError('Error'));
      await tester.pump();

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('should show empty message when no result', (tester) async {
      headerTitleCubit.emit('Movies');
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right([]));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      searchBloc.emit(SearchHasData([]));
      await tester.pump();

      expect(find.text('Data Not Found!'), findsOneWidget);
    });
  });

  group('SearchPage TV Shows', () {
    testWidgets('should show CircularProgressIndicator when loading',
        (tester) async {
      headerTitleCubit.emit('Tv Shows');
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Right([tTv]));

      searchTvBloc.add(OnQueryChangedTv(tQuery));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      searchTvBloc.emit(SearchLoadingTv());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show TvShowCard when data loaded', (tester) async {
      headerTitleCubit.emit('Tv Shows');
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Right([tTv]));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      searchTvBloc.emit(SearchHasDataTv([tTv]));
      await tester.pump();

      expect(find.text('Loki'), findsOneWidget);
    });

    testWidgets('should show error message when Error state', (tester) async {
      headerTitleCubit.emit('Tv Shows');
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Error')));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      searchTvBloc.emit(SearchErrorTv('Error'));
      await tester.pump();

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('should show empty message when no result', (tester) async {
      headerTitleCubit.emit('Tv Shows');
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Right([]));

      await tester.pumpWidget(makeTestableWidget(SearchPage()));
      searchTvBloc.emit(SearchHasDataTv([]));
      await tester.pump();

      expect(find.text('Data Not Found!'), findsOneWidget);
    });
  });
}
