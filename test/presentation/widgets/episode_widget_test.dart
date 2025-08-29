import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/presentation/widgets/episode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    // Inisialisasi locale untuk intl
    await initializeDateFormatting('en_US', null);
  });

  final longOverview = "This is the first episode of the series. "
      "It has a very long overview for testing purposes so that "
      "we can check the expand and collapse functionality properly. "
      "This should definitely be more than one hundred characters.";

  final testEpisode = Episode(
    episodeNumber: 1,
    seasonNumber: 1,
    name: "Pilot",
    overview: longOverview,
    stillPath: "/test.jpg",
    airDate: "2024-01-01", id: 1,
  );

  Widget makeTestable(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
    );
  }

  group("EpisodeWidget", () {
    testWidgets("should show overview collapsed by default", (tester) async {
      await tester.pumpWidget(makeTestable(EpisodeWidget(episode: testEpisode)));

      // cek teks ada
      expect(find.textContaining("This is the first episode"), findsOneWidget);
      // default collapsed → tombol "More..." muncul
      expect(find.text("More..."), findsOneWidget);
    });

    testWidgets("should expand and collapse overview on tap", (tester) async {
      await tester.pumpWidget(makeTestable(EpisodeWidget(episode: testEpisode)));

      // Expand
      await tester.tap(find.text("More..."));
      await tester.pump();
      expect(find.text("Close"), findsOneWidget);

      // Collapse lagi
      await tester.tap(find.text("Close"));
      await tester.pump();
      expect(find.text("More..."), findsOneWidget);
    });

    testWidgets("should show release date formatted", (tester) async {
      await tester.pumpWidget(makeTestable(EpisodeWidget(episode: testEpisode)));

      // cek tanggal terformat
      expect(find.textContaining("Jan"), findsOneWidget); // contoh: Jan 1, 2024
    });
  });
}
