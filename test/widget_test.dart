import 'package:flutter_test/flutter_test.dart';
import 'package:odotrack/main.dart';

void main() {
  testWidgets('Memuat halaman Riwayat Servis dengan benar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Riwayat Servis'), findsOneWidget);
    expect(find.text('Estimasi Servis Berikutnya'), findsOneWidget);
  });
}
