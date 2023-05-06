import 'package:flutter_test/flutter_test.dart';
import 'package:todai/main.dart';
import 'package:todai/time_blocks/stack.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TodaiApp());
    expect(find.byType(TimeBlockStack), findsOneWidget);
  });
}
