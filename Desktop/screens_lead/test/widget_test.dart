import 'package:flutter_test/flutter_test.dart';

import 'package:screens_lead/main.dart';

void main() {
  testWidgets('App builds StudentsScreen placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const StudentsApp());

    expect(find.text('StudentsScreen placeholder'), findsOneWidget);
  });
}
