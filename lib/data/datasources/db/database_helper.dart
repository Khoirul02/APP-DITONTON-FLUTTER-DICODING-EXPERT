import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_show_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _dbHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _dbHelper = this;
  }

  factory DatabaseHelper() => _dbHelper ?? DatabaseHelper._internal();

  static const String _tblWatchlistMovie = 'watchlist_movie';
  static const String _tblWatchlistTv = 'watchlist_tv';

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/ditonton.db',
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tblWatchlistMovie (
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            posterPath TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE $_tblWatchlistTv (
            id INTEGER PRIMARY KEY,
            name TEXT,
            overview TEXT,
            posterPath TEXT
          );
        ''');
      },
      version: 1,
    );
    return db;
  }

  // --- Metode untuk Film (Movie) ---
  Future<int> insertWatchlistMovie(MovieTable movie) async {
    final db = await database;
    return await db.insert(_tblWatchlistMovie, movie.toJson());
  }

  Future<int> removeWatchlistMovie(MovieTable movie) async {
    final db = await database;
    return await db.delete(
      _tblWatchlistMovie,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db.query(
      _tblWatchlistMovie,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db.query(_tblWatchlistMovie);
    return results;
  }

  // --- Metode Baru untuk Serial TV (Tv Show) ---
  Future<int> insertWatchlistTv(TvShowTable tvShow) async {
    final db = await database;
    return await db.insert(_tblWatchlistTv, tvShow.toJson());
  }

  Future<int> removeWatchlistTv(TvShowTable tvShow) async {
    final db = await database;
    return await db.delete(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [tvShow.id],
    );
  }

  Future<Map<String, dynamic>?> getTvShowById(int id) async {
    final db = await database;
    final results = await db.query(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTv() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(_tblWatchlistTv);
    return results;
  }
}
