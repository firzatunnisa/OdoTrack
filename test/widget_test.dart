import 'package:flutter_test/flutter_test.dart';
import 'package:odotrack/main.dart';

void main() {
  testWidgets('OdoTrack app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Halo, Nadila 👋'), findsOneWidget);
  });
}
