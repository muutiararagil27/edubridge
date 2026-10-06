import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Weekly Report',
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

          _reportCard(
            icon: Icons.school_rounded,
            title: 'Nilai Akademik',
            value: '87',
            description: 'Rata-rata nilai minggu ini',
          ),

          const SizedBox(height: 12),

          _reportCard(
            icon: Icons.build_rounded,
            title: 'Kegiatan Praktik',
            value: '80%',
            description: 'Perkembangan kegiatan praktik',
          ),

          const SizedBox(height: 12),

          _reportCard(
            icon: Icons.calendar_month_rounded,
            title: 'Kehadiran',
            value: '95%',
            description: 'Persentase kehadiran',
          ),

          const SizedBox(height: 12),

          _reportCard(
            icon: Icons.note_alt_outlined,
            title: 'Catatan Guru',
            value: 'Baik',
            description: 'Perkembangan belajar Ananda',
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