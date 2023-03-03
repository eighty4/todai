import 'package:flutter_test/flutter_test.dart';
import 'package:todai/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TodaiApp());
    expect(find.text('X'), findsOneWidget);
  });
}
