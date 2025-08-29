import 'package:ditonton/common/helper.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_show_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_show_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_show_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_show.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_show.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_show.dart';
import 'package:ditonton/domain/usecases/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_show.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_show.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_show.dart';
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
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => HeaderTitleCubit(),
  );

  locator.registerFactory(
    () => CurrentPageCubit(),
  );

  locator.registerFactory(
    () => SearchBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => SearchTvBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => MovieListCubit(
        getNowPlayingMovies: locator(),
        getPopularMovies: locator(),
        getTopRatedMovies: locator()),
  );

  locator.registerFactory(
    () => TvShowListCubit(
        getNowPlayingTvShow: locator(),
        getPopularTvShow: locator(),
        getTopRatedTvShow: locator()),
  );

  locator.registerFactory(
    () => MovieDetailCubit(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvShowDetailCubit(
      getTvShowDetail: locator(),
      getTvShowRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(
    () => PopularMoviesCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvShowCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvShowCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingTvShowCubit(
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieCubit(
      locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistTvShowCubit(
      locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingTvShow(locator()));
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetPopularTvShow(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvShow(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetTvShowDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => GetTvShowRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => SearchTvShow(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvShow(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvShow(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvShow(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvShow(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvShowRepository>(
    () => TvShowRepositoryImpl(
        remoteDataSource: locator(), localDataSource: locator()),
  );

  // external
  locator.registerSingletonAsync<http.Client>(
      () async => await Helper().createSSLClient());

  // data sources
  locator.registerSingletonWithDependencies<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
    dependsOn: [http.Client],
  );
  locator.registerSingletonWithDependencies<TvShowRemoteDataSource>(
    () => TvShowRemoteDataSourceImpl(client: locator()),
    dependsOn: [http.Client],
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvShowLocalDataSource>(
      () => TvShowLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
