import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class EvaluateRobot {
  final WidgetTester tester;
  const EvaluateRobot(this.tester);

  // TV Show Keys
  final listTvShowPopularKey = const ValueKey("listTvShowPopular");
  final listTvShowTopKey = const ValueKey("listTvShowTop");
  final listTvShowNowKey = const ValueKey("listTvShowNow");

  // Movie Keys
  final listMoviePopularKey = const ValueKey("listMoviePopular");
  final listMovieTopKey = const ValueKey("listMovieTop");
  final listMovieNowKey = const ValueKey("listMovieNow");

  /// Load UI
  Future<void> loadUI(Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  /// Open Drawer
  Future<void> openDrawer() async {
    final menuFinder = find.byTooltip('Open navigation menu');
    await tester.pumpAndSettle();
    expect(menuFinder, findsOneWidget);
    await tester.ensureVisible(menuFinder);
    await tester.tap(menuFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  /// Tap drawer item
  Future<void> tapDrawerItem(String text) async {
    await openDrawer();
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  /// Check header title
  Future<void> checkHeaderTitle(String title) async {
    expect(find.text(title), findsOneWidget);
  }

  /// Tap search icon
  Future<void> tapSearchIcon() async {
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
  }

  /// TV Show list checks
  Future<void> checkPopularList() async =>
      expect(find.byKey(listTvShowPopularKey), findsOneWidget);
  Future<void> checkTopRatedList() async =>
      expect(find.byKey(listTvShowTopKey), findsOneWidget);
  Future<void> checkNowPlayingList() async =>
      expect(find.byKey(listTvShowNowKey), findsOneWidget);

  /// Movie list checks
  Future<void> checkMoviePopularList() async =>
      expect(find.byKey(listMoviePopularKey), findsOneWidget);
  Future<void> checkMovieTopRatedList() async =>
      expect(find.byKey(listMovieTopKey), findsOneWidget);
  Future<void> checkMovieNowPlayingList() async =>
      expect(find.byKey(listMovieNowKey), findsOneWidget);
}
