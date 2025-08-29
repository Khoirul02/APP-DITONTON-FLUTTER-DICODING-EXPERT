import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/presentation/bloc/movie_list_state.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_state.dart';
import 'package:ditonton/presentation/bloc/tv_show_list_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_state.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:ditonton/presentation/widgets/watchlist_movie_widget.dart';
import 'package:ditonton/presentation/widgets/watchlist_tv_show_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/presentation/pages/main_page.dart';
import 'package:ditonton/presentation/pages/home_tv_show_page.dart';
import 'package:ditonton/presentation/bloc/current_page_cubit.dart';
import 'package:ditonton/presentation/bloc/header_title_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_list_cubit.dart';
import 'package:ditonton/presentation/bloc/movie_list_cubit.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/search_tv_bloc.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_show.dart';

import '../test/dummy_data/dummy_objects.dart';
import '../test/dummy_data/dummy_objects_tv_show.dart';
import 'robot/evaluate_robot.dart';

// Mock classes
class MockGetNowPlayingTvShow extends Mock implements GetNowPlayingTvShow {}
class MockGetPopularTvShow extends Mock implements GetPopularTvShow {}
class MockGetTopRatedTvShow extends Mock implements GetTopRatedTvShow {}
class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}
class MockGetPopularMovies extends Mock implements GetPopularMovies {}
class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}
class MockSearchMovies extends Mock implements SearchMovies {}
class MockSearchTv extends Mock implements SearchTvShow {}
class MockGetTvShowDetail extends Mock implements GetTvShowDetail {}
class MockGetTvShowRecommendations extends Mock implements GetTvShowRecommendations {}
class MockGetWatchlistStatus extends Mock implements GetWatchListStatusTvShow {}
class MockSaveWatchlist extends Mock implements SaveWatchlistTvShow {}
class MockRemoveWatchlist extends Mock implements RemoveWatchlistTvShow {}
class MockWatchlistTvShowCubit extends MockCubit<WatchlistTvShowState>
    implements WatchlistTvShowCubit {}

class MockWatchlistMovieCubit extends MockCubit<WatchlistMovieState>
    implements WatchlistMovieCubit {}

class FakeTvShowDetail extends Fake implements TvShowDetail {}


void main() {
  setUpAll(() {
    registerFallbackValue(FakeTvShowDetail());
  });
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockGetNowPlayingTvShow mockNowPlayingTv;
  late MockGetPopularTvShow mockPopularTv;
  late MockGetTopRatedTvShow mockTopRatedTv;
  late MockGetNowPlayingMovies mockNowPlayingMovies;
  late MockGetPopularMovies mockPopularMovies;
  late MockGetTopRatedMovies mockTopRatedMovies;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTv mockSearchTv;
  late MockGetTvShowDetail mockGetTvShowDetail;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;
  late MockGetWatchlistStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockWatchlistTvShowCubit mockWatchlistTvShowCubit;
  late MockWatchlistMovieCubit mockWatchlistMovieCubit;

  setUp(() {
    // TV Show
    mockNowPlayingTv = MockGetNowPlayingTvShow();
    mockPopularTv = MockGetPopularTvShow();
    mockTopRatedTv = MockGetTopRatedTvShow();
    when(() => mockNowPlayingTv.execute()).thenAnswer((_) async => Right([testTvShow]));
    when(() => mockPopularTv.execute()).thenAnswer((_) async => Right([testTvShow]));
    when(() => mockTopRatedTv.execute()).thenAnswer((_) async => Right([testTvShow]));

    // Movies
    mockNowPlayingMovies = MockGetNowPlayingMovies();
    mockPopularMovies = MockGetPopularMovies();
    mockTopRatedMovies = MockGetTopRatedMovies();
    when(() => mockNowPlayingMovies.execute()).thenAnswer((_) async => Right([testMovie]));
    when(() => mockPopularMovies.execute()).thenAnswer((_) async => Right([testMovie]));
    when(() => mockTopRatedMovies.execute()).thenAnswer((_) async => Right([testMovie]));

    // Search TV Show
    mockSearchMovies = MockSearchMovies();
    mockSearchTv = MockSearchTv();
    when(() => mockSearchMovies.execute(any())).thenAnswer((_) async => Right([testMovie]));
    when(() => mockSearchTv.execute(any())).thenAnswer((_) async => Right([testTvShow]));

    // Detail
    mockGetTvShowDetail = MockGetTvShowDetail();
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    when(() => mockGetTvShowDetail.execute(any())).thenAnswer((_) async => Right(testTvShowDetail));
    when(() => mockGetTvShowRecommendations.execute(any())).thenAnswer((_) async => Right([testTvShow]));
    when(() => mockGetWatchlistStatus.execute(any())).thenAnswer((_) async => false);
    when(() => mockSaveWatchlist.execute(any())).thenAnswer((_) async => Right('Added to Watchlist'));
    when(() => mockRemoveWatchlist.execute(any())).thenAnswer((_) async => Right('Removed from Watchlist'));

    // Watchlist
    mockWatchlistTvShowCubit = MockWatchlistTvShowCubit();
    mockWatchlistMovieCubit = MockWatchlistMovieCubit();
    
    whenListen(
      mockWatchlistTvShowCubit,
      Stream.fromIterable([
        WatchlistTvShowLoading(),
        WatchlistTvShowHasData([testTvShow]), // <-- setelah fetch
      ]),
      initialState: WatchlistTvShowLoading(),
    );

    whenListen(
      mockWatchlistMovieCubit,
      Stream.fromIterable([
        WatchlistMovieLoading(),
        WatchlistMovieHasData([]),
      ]),
      initialState: WatchlistMovieLoading(),
    );

    // biar nggak error kalau dipanggil
    when(() => mockWatchlistTvShowCubit.fetchWatchlistTvShow())
        .thenAnswer((_) async => Future.value());
    when(() => mockWatchlistMovieCubit.fetchWatchlistMovies())
        .thenAnswer((_) async => Future.value());
  });

  testWidgets('MainPage integration test to Add TV Show', (tester) async {
    final evaluateRobot = EvaluateRobot(tester);

    final tvShowCubit = TvShowListCubit(
      getNowPlayingTvShow: mockNowPlayingTv,
      getPopularTvShow: mockPopularTv,
      getTopRatedTvShow: mockTopRatedTv,
    );
    tvShowCubit.emit(TvShowListHasData(
      nowPlaying: [testTvShow],
      popular: [testTvShow],
      topRated: [testTvShow],
    ));

    final movieCubit = MovieListCubit(
      getNowPlayingMovies: mockNowPlayingMovies,
      getPopularMovies: mockPopularMovies,
      getTopRatedMovies: mockTopRatedMovies,
    );
    movieCubit.emit(MovieListHasData(
      nowPlaying: [testMovie],
      popular: [testMovie],
      topRated: [testMovie],
    ));

    final detailCubit = TvShowDetailCubit(
      getTvShowDetail: mockGetTvShowDetail,
      getTvShowRecommendations: mockGetTvShowRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );

    // Emit initial detail state
    detailCubit.emit(TvShowDetailHasData(
      tvShow: testTvShowDetail,
      recommendations: [testTvShow],
      isAddedToWatchlist: false,
      watchlistMessage: '',
    ));

    // --- Load UI dengan BlocProvider.value untuk cubit yang sudah emit ---
    await evaluateRobot.loadUI(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: tvShowCubit),
          BlocProvider.value(value: movieCubit),
          BlocProvider(create: (_) => HeaderTitleCubit()..changeHeaderTitle('TV Show')),
          BlocProvider(create: (_) => CurrentPageCubit()..changeCurrentPage(HomeTvShowPage())),
          BlocProvider(create: (_) => SearchBloc(mockSearchMovies)),
          BlocProvider(create: (_) => SearchTvBloc(mockSearchTv)),
          BlocProvider(create: (_) => TvShowDetailCubit(
            getTvShowDetail: mockGetTvShowDetail,
            getTvShowRecommendations: mockGetTvShowRecommendations,
            getWatchListStatus: mockGetWatchlistStatus,
            saveWatchlist: mockSaveWatchlist,
            removeWatchlist: mockRemoveWatchlist,
          )),
          BlocProvider<WatchlistTvShowCubit>.value(value: mockWatchlistTvShowCubit),
          BlocProvider<WatchlistMovieCubit>.value(value: mockWatchlistMovieCubit),
        ],
        child: MaterialApp(home: MainPage(),routes: {
          SearchPage.ROUTE_NAME: (_) => SearchPage(),
          TvShowDetailPage.ROUTE_NAME: (context) {
              final id = ModalRoute.of(context)!.settings.arguments as int;
              return TvShowDetailPage(id: id);
          },
          WatchlistPage.ROUTE_NAME: (_) => WatchlistPage(),
        }),
      ),
    );

    await tester.pumpAndSettle();

    // ==== TV Show ====
    await evaluateRobot.checkHeaderTitle('TV Show');
    await evaluateRobot.checkPopularList();
    await evaluateRobot.checkTopRatedList();
    await evaluateRobot.checkNowPlayingList();

    // ==== Movies ====
    await evaluateRobot.tapDrawerItem('Movies');
    await evaluateRobot.checkHeaderTitle('Movies');
    await evaluateRobot.checkMoviePopularList();
    await evaluateRobot.checkMovieTopRatedList();
    await evaluateRobot.checkMovieNowPlayingList();

    // ==== Back to TV Show ====
    await evaluateRobot.tapDrawerItem('TV Show');
    await evaluateRobot.checkHeaderTitle('TV Show');

    // ==== Search ====
    await evaluateRobot.tapSearchIcon();
    expect(find.text('Search of TV Show'), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 2));

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Test Query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    // ==== Search results appear ====
    expect(find.text(testTvShow.name!), findsWidgets);

    // ==== Tap first result to go detail ====
    await tester.tap(find.byType(TvShowCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(TvShowDetailPage), findsOneWidget);
    expect(find.text(testTvShowDetail.name), findsOneWidget);

    // ==== Cari button Watchlist berdasarkan Text('Watchlist') ====
    final watchlistButton = find.ancestor(
      of: find.text('Watchlist'),
      matching: find.byType(ElevatedButton),
    );

    // Pastikan button ada
    expect(watchlistButton, findsOneWidget);

    // ==== Awal harus icon add ====
    expect(
      find.descendant(
        of: watchlistButton,
        matching: find.byIcon(Icons.add),
      ),
      findsOneWidget,
    );

    // ==== Tap untuk add ke watchlist ====
    await tester.tap(watchlistButton);
    await tester.pump();

    // Emit state baru untuk trigger rebuild
    detailCubit.emit(TvShowDetailHasData(
      tvShow: testTvShowDetail,
      recommendations: [testTvShow],
      isAddedToWatchlist: true,
      watchlistMessage: 'Added to Watchlist',
    ));
    await tester.pumpAndSettle();

    // ==== Sekarang icon check muncul ====
    expect(
      find.descendant(
        of: watchlistButton,
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
    await tester.pumpAndSettle(Duration(seconds: 2));

    // ==== Tap untuk kembali ke MainPage (Dua Kali) ====
    final backButton = find.byIcon(Icons.arrow_back);
    expect(backButton, findsOneWidget);
    
    final backButtonSearch = find.byIcon(Icons.arrow_back);
    expect(backButtonSearch, findsOneWidget);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    await tester.tap(backButtonSearch);
    await tester.pumpAndSettle();

    // ==== Cek header title di MainPage (TV Show) ====
    await evaluateRobot.checkHeaderTitle('TV Show');

    // ==== Bisa lanjut cek list TV Show tetap tampil ====
    await evaluateRobot.checkPopularList();
    await evaluateRobot.checkTopRatedList();
    await evaluateRobot.checkNowPlayingList();

    // ==== Buka drawer dan navigasi ke WatchlistPage ====
    await evaluateRobot.openDrawer();
    await evaluateRobot.tapDrawerItem('Watchlist');
    await tester.pumpAndSettle();

    // ==== Pastikan berada di Watchlist ====
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('TV Shows'), findsOneWidget);
    expect(find.byType(WatchlistTvShowWidget), findsOneWidget);

    // ==== Pindah ke tab Movies ====
    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();

    // Pastikan konten Movies muncul
    expect(find.text('Movies'), findsOneWidget);
    expect(find.byType(WatchlistMovieWidget), findsOneWidget);

    // ==== Balik lagi ke tab TV Shows ====
    await tester.tap(find.text('TV Shows'));
    await tester.pumpAndSettle();

    // Pastikan konten TV Shows muncul lagi
    expect(find.text('TV Shows'), findsOneWidget);
    expect(find.byType(WatchlistTvShowWidget), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 2));
  });
}
