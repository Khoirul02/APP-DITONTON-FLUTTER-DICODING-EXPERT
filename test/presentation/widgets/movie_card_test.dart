import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {

  Widget makeTestable(Widget body) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.ROUTE_NAME) {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => Scaffold(body: Text("Movie Detail Page: $id")),
          );
        }
        return null;
      },
      home: Scaffold(body: body),
    );
  }

  testWidgets("should display movie title and overview", (tester) async {
    await tester.pumpWidget(makeTestable(MovieCard(testMovie)));

    expect(find.text("Spider-Man"), findsOneWidget);
    expect(
      find.textContaining("After being bitten by a genetically altered spider"),
      findsOneWidget,
    );
  });

  testWidgets("should load image using CachedNetworkImage", (tester) async {
    await tester.pumpWidget(makeTestable(MovieCard(testMovie)));

    expect(find.byType(CachedNetworkImage), findsOneWidget);

    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    expect(image.imageUrl, "$BASE_IMAGE_URL${testMovie.posterPath}");
  });

  testWidgets("should navigate to MovieDetailPage on tap", (tester) async {
    await tester.pumpWidget(makeTestable(MovieCard(testMovie)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text("Movie Detail Page: 557"), findsOneWidget);
  });

  testWidgets("should show fallback '-' if title or overview is null", (tester) async {
    final movieWithNulls = Movie(
      adult: false,
      backdropPath: null,
      genreIds: [],
      id: 999,
      originalTitle: null,
      overview: null,
      popularity: 0,
      posterPath: null,
      releaseDate: null,
      title: null,
      video: false,
      voteAverage: 0,
      voteCount: 0,
    );

    await tester.pumpWidget(makeTestable(MovieCard(movieWithNulls)));

    expect(find.text("-"), findsWidgets); // muncul 2x (title dan overview)
  });
}
