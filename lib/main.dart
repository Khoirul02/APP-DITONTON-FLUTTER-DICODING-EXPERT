import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/current_page_cubit.dart';
import 'package:ditonton/presentation/bloc/header_title_cubit.dart';
import 'package:ditonton/presentation/bloc/movie_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/movie_list_cubit.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/popular_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/search_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_list_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_cubit.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/main_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_palying_tv_show_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_show_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_show_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  di.init();
  await di.locator.allReady();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<HeaderTitleCubit>()),
        BlocProvider(create: (_) => di.locator<CurrentPageCubit>()),
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
            create: (_) => MovieListCubit(
                  getNowPlayingMovies: di.locator(),
                  getPopularMovies: di.locator(),
                  getTopRatedMovies: di.locator(),
                )),
        BlocProvider(
            create: (_) => TvShowListCubit(
                  getNowPlayingTvShow: di.locator(),
                  getPopularTvShow: di.locator(),
                  getTopRatedTvShow: di.locator(),
                )),
        BlocProvider(
          create: (_) => MovieDetailCubit(
            getMovieDetail: di.locator(),
            getMovieRecommendations: di.locator(),
            getWatchListStatus: di.locator(),
            saveWatchlist: di.locator(),
            removeWatchlist: di.locator(),
          ),
        ),
        BlocProvider(
          create: (_) => TvShowDetailCubit(
            getTvShowDetail: di.locator(),
            getTvShowRecommendations: di.locator(),
            getWatchListStatus: di.locator(),
            saveWatchlist: di.locator(),
            removeWatchlist: di.locator(),
          ),
        ),
        BlocProvider(
          create: (_) => PopularMoviesCubit(di.locator()),
        ),
        BlocProvider(
          create: (_) => PopularTvShowCubit(di.locator()),
        ),
        BlocProvider(
          create: (_) => TopRatedMoviesCubit(di.locator()),
        ),
        BlocProvider(
          create: (_) => TopRatedTvShowCubit(di.locator()),
        ),
        BlocProvider(
          create: (_) => NowPlayingTvShowCubit(di.locator()),
        ),
        BlocProvider(
          create: (_) => WatchlistMovieCubit(di.locator()),
        ),
        BlocProvider(
          create: (_) => WatchlistTvShowCubit(di.locator()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: MainPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/main':
              return MaterialPageRoute(builder: (_) => MainPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case PopularTvShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvShowPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case TopRatedTvShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvShowPage());
            case NowPalyingTvShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => NowPalyingTvShowPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TvShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvShowDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
