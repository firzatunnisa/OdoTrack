import 'package:flutter_test/flutter_test.dart';
import 'package:odotrack/main.dart';

void main() {
  testWidgets('OdoTrack app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify landing page renders
    expect(find.text('Mulai Sekarang'), findsOneWidget);
  });
}
