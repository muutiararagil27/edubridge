import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'grade_input_screen.dart';
import 'attendance_input_screen.dart';
import 'report_screen.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'EduBridge',
          style: TextStyle(
            color: Color(0xFF2457C5),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Keluar',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Dashboard Guru',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selamat datang kembali, Bapak/Ibu Guru!',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2457C5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 36,
                ),
                SizedBox(height: 14),
                Text(
                  'Pantau Perkembangan Siswa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Kelola nilai, kehadiran, dan catatan '
                  'perkembangan siswa melalui EduBridge.',
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Ringkasan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  icon: Icons.people_alt_outlined,
                  title: 'Total Siswa',
                  value: '30',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  icon: Icons.assignment_outlined,
                  title: 'Input Nilai',
                  value: '0',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Menu Guru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          _menuCard(
            context,
            icon: Icons.edit_note,
            title: 'Input Nilai Siswa',
            subtitle: 'Kelola nilai akademik siswa',
            color: Colors.blue,
          ),
          _menuCard(
            context,
            icon: Icons.fact_check_outlined,
            title: 'Kehadiran Siswa',
            subtitle: 'Catat dan pantau kehadiran',
            color: Colors.green,
          ),
          _menuCard(
            context,
            icon: Icons.sticky_note_2_outlined,
            title: 'Catatan Perkembangan',
            subtitle: 'Tambahkan catatan perilaku siswa',
            color: Colors.orange,
          ),
          _menuCard(
            context,
            icon: Icons.bar_chart,
            title: 'Laporan Siswa',
            subtitle: 'Lihat ringkasan perkembangan siswa',
            color: Colors.purple,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: const Color(0xFF2457C5),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Siswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  static Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (title == 'Input Nilai Siswa') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GradeInputScreen(),
              ),
            );
          } else if (title == 'Kehadiran Siswa') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AttendanceInputScreen(),
              ),
            );
          } else if (title == 'Laporan Siswa') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title belum tersedia.'),
              ),
            );
          }
        },
      ),
    );
  }
}