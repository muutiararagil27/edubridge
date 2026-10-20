import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge/main.dart';

void main() {
  testWidgets('Dashboard Guru berhasil ditampilkan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduBridgeApp());

    await tester.pumpAndSettle();

    expect(find.text('Dashboard Guru'), findsOneWidget);
    expect(find.text('Pantau Perkembangan Siswa'), findsOneWidget);
    expect(find.text('Total Siswa'), findsOneWidget);
  });
}