import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // Untuk keperluan testing, kita asumsikan ID/Nama siswa yang sedang login.
  // Nanti nilai ini didapatkan dari Firebase Authentication.
  final String namaSiswaTest = 'Andi Pratama'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Laporan Mingguan', // Sudah diubah ke Bahasa Indonesia
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Laporan Perkembangan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '21 - 27 September 2026',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),

          // --- RINGKASAN STATIS ---
          _reportCard(
            icon: Icons.school_rounded,
            title: 'Nilai Akademik',
            value: '87',
            description: 'Rata-rata nilai minggu ini',
          ),
          const SizedBox(height: 12),
          _reportCard(
            icon: Icons.calendar_month_rounded,
            title: 'Kehadiran',
            value: '95%',
            description: 'Persentase kehadiran',
          ),
          const SizedBox(height: 24),

          // --- BAGIAN REAL-TIME DARI FIREBASE ---
          const Text(
            'Riwayat Nilai Terbaru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // StreamBuilder untuk membaca data Firestore secara Real-Time
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Nilai')
                .where('siswaId', isEqualTo: namaSiswaTest)
                .orderBy('Tanggal', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Error memuat data: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('Belum ada nilai yang diinput oleh guru.'),
                  ),
                );
              }

              var daftarNilai = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daftarNilai.length,
                itemBuilder: (context, index) {
                  var data = daftarNilai[index].data() as Map<String, dynamic>;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _reportCard(
                      icon: Icons.menu_book_rounded,
                      title: data['mataPelajaran'] ?? 'Mata Pelajaran',
                      value: data['Nilai']?.toString() ?? '0',
                      description: data['jenisPenilaian'] ?? 'Evaluasi',
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _reportCard({
    required IconData icon,
    required String title,
    required String value,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EDFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF3155D9),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF3155D9),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}