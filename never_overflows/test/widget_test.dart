import 'package:flutter_test/flutter_test.dart';
import 'package:never_overflows/main.dart';

void main() {
  testWidgets('Contacts screen loads correctly', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('20 contacts'), findsOneWidget);
    expect(find.text('Aida Akhmetova'), findsOneWidget);
    expect(find.text('Dias Nurlanov'), findsOneWidget);
  });
}