import 'package:flutter_test/flutter_test.dart';

import 'package:todai/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TodaiApp());
    expect(find.text('Today'), findsOneWidget);
  });
}
