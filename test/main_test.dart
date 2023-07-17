import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todai/main.dart';
import 'package:todai/splash_screen/intro.dart';
import 'package:todai/time_blocks/stack.dart';

void main() {
  testWidgets('Shows intro', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'intro': false,
    });
    await tester.pumpWidget(const TodaiApp());
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(IntroSequence), findsOneWidget);
  });

  // todo fails to find GestureDetector in app
  // testWidgets('Traverses intro', (WidgetTester tester) async {
  //   SharedPreferences.setMockInitialValues({
  //     'intro': false,
  //   });
  //   await tester.pumpWidget(const TodaiApp());
  //   await tester.pump(const Duration(milliseconds: 20000));
  //   expect(find.byType(IntroSequence), findsOneWidget);
  //   await tester.tap(find.byType(GestureDetector));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(GestureDetector));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(GestureDetector));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(GestureDetector));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(GestureDetector));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(GestureDetector));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(TimeBlockStack), findsOneWidget);
  // });

  testWidgets('Skips intro', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'intro': true,
    });
    await tester.pumpWidget(const TodaiApp());
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(TimeBlockStack), findsOneWidget);
  });
}
