// File: test/helpers/test_helper.dart

import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

// Import semua data source dan repository yang akan di-mock
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_show_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_show_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';

@GenerateMocks([
  MovieRepository,
  TvShowRepository,
  MovieRemoteDataSource,
  TvShowRemoteDataSource,
  MovieLocalDataSource,
  TvShowLocalDataSource,
  DatabaseHelper,
], customMocks: [
  // Custom mock untuk http.Client
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}