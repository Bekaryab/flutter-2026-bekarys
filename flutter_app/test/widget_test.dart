import 'package:flutter_test/flutter_test.dart';
import 'package:qadam_events/app/qadam_app.dart';

void main() {
  testWidgets('Qadam Events starts on the events tab', (tester) async {
    await tester.pumpWidget(const QadamApp());
    expect(find.text('Qadam Events'), findsOneWidget);
    expect(find.text('Campus AI Builders Meetup'), findsOneWidget);
  });
}
