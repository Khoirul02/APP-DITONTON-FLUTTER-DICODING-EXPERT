import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestable(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('should display logo and description text', (tester) async {
    await tester.pumpWidget(makeTestable( AboutPage()));
    expect(find.byType(Image), findsOneWidget);
    expect(
      find.textContaining('Ditonton merupakan sebuah aplikasi katalog film'),
      findsOneWidget,
    );
  });

  testWidgets('should display back button and pop when pressed', (tester) async {
    final navKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navKey,
        home: AboutPage(),
      ),
    );

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    await tester.tap(find.byKey(const Key('about_back_button')));
    await tester.pumpAndSettle();

    expect(navKey.currentState?.canPop(), isFalse);
  });
}
