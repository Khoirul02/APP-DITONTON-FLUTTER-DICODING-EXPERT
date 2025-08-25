import 'package:ditonton/data/models/tv_show_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';

final testTvShow = TvShow(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalName: 'Wednesday',
  overview:
      'Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.',
  popularity: 60.441,
  firstAirDate: '2022-11-23',
  posterPath: '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
  name: 'Wednesday',
  voteAverage: 8.408,
  voteCount: 9348,
);

final testTvShowList = [testTvShow];

final testTvShowDetail = TvShowDetail(
  backdropPath: '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
  genres: [Genre(id: 1, name: 'Action')],
  id: 557,
  name: 'Wednesday',
  overview: 'Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.',
  posterPath: '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
  firstAirDate: 'releaseDate',
  voteAverage: 1,
  voteCount: 1, episodeRunTime: [], numberOfEpisodes: 1, numberOfSeasons: 1, seasons: [],
);

final testWatchlistTvShow = TvShow.watchlist(
  id: 557,
  name: 'Wednesday',
  posterPath: '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
  overview: 'Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.',
);

final testTvShowTable = TvShowTable(
  id: 557,
  name: 'Wednesday',
  posterPath: '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
  overview: 'Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.',
);

final testTvShowMap = {
  'id': 557,
  'overview': 'Smart, sarcastic and a little dead inside, Wednesday Addams investigates twisted mysteries while making new friends — and foes — at Nevermore Academy.',
  'posterPath': '/qg8Gv2w0dDL8cMsG2QO2hWp58wy.jpg',
  'name': 'Wednesday',
};
