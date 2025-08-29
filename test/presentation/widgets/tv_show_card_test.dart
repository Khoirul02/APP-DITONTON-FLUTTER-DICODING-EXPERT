import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects_tv_show.dart';

void main() {
  Widget makeTestable(Widget body) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == TvShowDetailPage.ROUTE_NAME) {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => Scaffold(body: Text("TV Show Detail Page: $id")),
          );
        }
        return null;
      },
      home: Scaffold(body: body),
    );
  }

  testWidgets("should display tv show name and overview", (tester) async {
    await tester.pumpWidget(makeTestable(TvShowCard(testTvShow)));

    expect(find.text("Wednesday"), findsOneWidget);
    expect(
      find.textContaining("Smart, sarcastic and a little dead inside"),
      findsOneWidget,
    );
  });

  testWidgets("should load image using CachedNetworkImage", (tester) async {
    await tester.pumpWidget(makeTestable(TvShowCard(testTvShow)));

    expect(find.byType(CachedNetworkImage), findsOneWidget);

    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    expect(image.imageUrl, "$BASE_IMAGE_URL${testTvShow.posterPath}");
  });

  testWidgets("should navigate to TvShowDetailPage on tap", (tester) async {
    await tester.pumpWidget(makeTestable(TvShowCard(testTvShow)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text("TV Show Detail Page: 557"), findsOneWidget);
  });

  testWidgets("should show fallback '-' if name is null", (tester) async {
    final tvShowWithNullName = TvShow(
      backdropPath: null,
      firstAirDate: null,
      genreIds: [],
      id: 999,
      name: null,
      originalName: null,
      overview: "Some overview",
      popularity: 0,
      posterPath: null,
      voteAverage: 0,
      voteCount: 0,
    );

    await tester.pumpWidget(makeTestable(TvShowCard(tvShowWithNullName)));

    expect(find.text("-"), findsOneWidget);
  });
}
