import 'package:flutter_test/flutter_test.dart';
import 'package:edubridge/main.dart';

void main() {
  testWidgets('Dashboard Guru berhasil ditampilkan', (
    WidgetTester tester,
  ) async {
    // Membuka aplikasi EduBridge.
    await tester.pumpWidget(const EduBridgeApp());

    // Memastikan judul dashboard tampil.
    expect(find.text('Dashboard Guru'), findsOneWidget);

    // Memastikan menu input nilai tersedia.
    expect(find.text('Input Nilai Siswa'), findsOneWidget);

    // Memastikan menu kehadiran tersedia.
    expect(find.text('Kehadiran Siswa'), findsOneWidget);

    // Memastikan menu laporan siswa tersedia.
    expect(find.text('Laporan Siswa'), findsOneWidget);
  });
}