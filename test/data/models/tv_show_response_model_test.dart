import 'dart:convert';
import 'package:ditonton/data/models/tv_show_model.dart';
import 'package:ditonton/data/models/tv_show_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvShowModel = TvShowModel(
    backdropPath: "/kIgzX0QdvK3vtaoHBpj9fUy7DP9.jpg",
    firstAirDate: "2014-04-25",
    genreIds: [10764],
    id: 121876,
    name: "Divas Hit the Road",
    originalName: "Divas Hit the Road",
    overview: "Overview",
    popularity: 539.9468,
    posterPath: "/xj8EEPB0ipfja5ZbcJLGucZtoUA.jpg",
    voteAverage: 7.333,
    voteCount: 6,
  );
  final tTvShowResponseModel =
      TvShowResponse(tvShowList: <TvShowModel>[tTvShowModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing_tv_show.json'));
      // act
      final result = TvShowResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvShowResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvShowResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/kIgzX0QdvK3vtaoHBpj9fUy7DP9.jpg",
            "genre_ids": [10764],
            "id": 121876,
            "original_name": "Divas Hit the Road",
            "overview": "Overview",
            "popularity": 539.9468,
            "poster_path": "/xj8EEPB0ipfja5ZbcJLGucZtoUA.jpg",
            "first_air_date": "2014-04-25",
            "name": "Divas Hit the Road",
            "vote_average": 7.333,
            "vote_count": 6
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}