import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_show_table.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseHelper databaseHelper;

  setUp(() async {
    databaseHelper = DatabaseHelper();
    // Hapus database lama supaya fresh
    var path = await databaseFactory.getDatabasesPath();
    await databaseFactory.deleteDatabase('$path/ditonton.db');
  });

  group('DatabaseHelper Movie Watchlist', () {
    final tMovie = MovieTable(
      id: 1,
      title: 'Movie Title',
      overview: 'Movie Overview',
      posterPath: '/poster.jpg',
    );

    test('should insert movie into watchlist', () async {
      final result = await databaseHelper.insertWatchlistMovie(tMovie);
      expect(result, 1);
    });

    test('should remove movie from watchlist', () async {
      await databaseHelper.insertWatchlistMovie(tMovie);
      final result = await databaseHelper.removeWatchlistMovie(tMovie);
      expect(result, 1);
    });

    test('should get movie by id', () async {
      await databaseHelper.insertWatchlistMovie(tMovie);
      final result = await databaseHelper.getMovieById(1);
      expect(result!['title'], tMovie.title);
    });

    test('should return null when movie not found', () async {
      final result = await databaseHelper.getMovieById(999);
      expect(result, null);
    });

    test('should get all movies in watchlist', () async {
      await databaseHelper.insertWatchlistMovie(tMovie);
      final result = await databaseHelper.getWatchlistMovies();
      expect(result.length, 1);
      expect(result.first['id'], tMovie.id);
    });
  });

  group('DatabaseHelper TV Show Watchlist', () {
    final tTvShow = TvShowTable(
      id: 1,
      name: 'TV Show Name',
      overview: 'TV Show Overview',
      posterPath: '/poster.jpg',
    );

    test('should insert tv show into watchlist', () async {
      final result = await databaseHelper.insertWatchlistTv(tTvShow);
      expect(result, 1);
    });

    test('should remove tv show from watchlist', () async {
      await databaseHelper.insertWatchlistTv(tTvShow);
      final result = await databaseHelper.removeWatchlistTv(tTvShow);
      expect(result, 1);
    });

    test('should get tv show by id', () async {
      await databaseHelper.insertWatchlistTv(tTvShow);
      final result = await databaseHelper.getTvShowById(1);
      expect(result!['name'], tTvShow.name);
    });

    test('should return null when tv show not found', () async {
      final result = await databaseHelper.getTvShowById(999);
      expect(result, null);
    });

    test('should get all tv shows in watchlist', () async {
      await databaseHelper.insertWatchlistTv(tTvShow);
      final result = await databaseHelper.getWatchlistTv();
      expect(result.length, 1);
      expect(result.first['id'], tTvShow.id);
    });
  });
}
