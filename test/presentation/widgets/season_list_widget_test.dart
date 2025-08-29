import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/presentation/widgets/season_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() async {
    Intl.defaultLocale = 'en_US';
    await initializeDateFormatting('en_US', null);
  });

  group('SeasonListWidget', () {
    testWidgets('should render SizedBox.shrink when seasons is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeasonListWidget(seasons: []),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should show Unknown when airDate is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeasonListWidget(
              seasons: [
                Season(
                  airDate: null,
                  episodeCount: 5,
                  id: 2,
                  name: 'Season X',
                  overview: 'Overview season X',
                  posterPath: null,
                  seasonNumber: 2,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Season X'), findsOneWidget);
      expect(find.textContaining('Unknown'), findsOneWidget);
    });

    testWidgets('should show formatted date when airDate is available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeasonListWidget(
              seasons: [
                Season(
                  airDate: '2020-10-10',
                  episodeCount: 10,
                  id: 3,
                  name: 'Season Y',
                  overview: 'Overview season Y',
                  posterPath: null,
                  seasonNumber: 3,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Season Y'), findsOneWidget);
      expect(find.textContaining('Oct'), findsOneWidget); // formatted date
    });

    testWidgets('should show poster when posterPath is not null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeasonListWidget(
              seasons: [
                Season(
                  airDate: '2021-05-05',
                  episodeCount: 8,
                  id: 4,
                  name: 'Season Z',
                  overview: 'Overview season Z',
                  posterPath: '/testPoster.jpg',
                  seasonNumber: 4,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Season Z'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
