import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'grade_input_screen.dart';
import 'mass_attendance_screen.dart';
import 'report_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  int _selectedIndex = 0;

  // Daftar halaman untuk navigasi bawah
  final List<Widget> _pages = [
    const _DashboardView(),
    const _StudentListView(),
    const _PlaceholderScreen(title: 'Pesan / Chat'),
    const _PlaceholderScreen(title: 'Profil Guru'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'EduBridge',
          style: TextStyle(color: Color(0xFF2457C5), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2457C5),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Siswa'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Dashboard Guru - XI-A3', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Selamat datang kembali, Bapak/Ibu Guru!', style: TextStyle(color: Colors.black54)),
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
              Icon(Icons.school, color: Colors.white, size: 36),
              SizedBox(height: 14),
              Text('Pantau Perkembangan Siswa', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Kelola nilai, kehadiran, dan catatan perkembangan.', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Ringkasan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        Row(
          children: [
            const Expanded(
              child: _SummaryCard(icon: Icons.people_alt_outlined, title: 'Total Siswa', value: '10', color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Nilai').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const _SummaryCard(
                      icon: Icons.assignment_outlined,
                      title: 'Memuat...',
                      value: '...',
                      color: Colors.orange,
                    );
                  }
                  if (snapshot.hasError) {
                    return const _SummaryCard(
                      icon: Icons.error_outline,
                      title: 'Error',
                      value: '-',
                      color: Colors.red,
                    );
                  }

                  String totalNilai = '0';
                  if (snapshot.hasData) {
                    totalNilai = snapshot.data!.docs.length.toString();
                  }

                  return _SummaryCard(
                    icon: Icons.assignment_outlined,
                    title: 'Input Nilai',
                    value: totalNilai,
                    color: Colors.orange,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Menu Guru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        _MenuCard(
          icon: Icons.edit_note, title: 'Input Nilai Siswa', subtitle: 'Kelola nilai akademik siswa', color: Colors.blue,
          targetScreen: const GradeInputScreen(),
        ),
        _MenuCard(
          icon: Icons.fact_check_outlined, title: 'Kehadiran Siswa', subtitle: 'Catat dan pantau kehadiran', color: Colors.green,
          targetScreen: const MassAttendanceScreen(),
        ),
        _MenuCard(
          icon: Icons.sticky_note_2_outlined, title: 'Catatan Perkembangan', subtitle: 'Tambahkan catatan perilaku siswa', color: Colors.orange,
          targetScreen: const _PlaceholderScreen(title: 'Form Catatan Perkembangan'),
        ),
        _MenuCard(
          icon: Icons.bar_chart, title: 'Laporan Siswa', subtitle: 'Lihat ringkasan perkembangan siswa', color: Colors.purple,
          targetScreen: const ReportScreen(),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({required this.icon, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget targetScreen;

  const _MenuCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.targetScreen});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen)),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Center(child: Text('Fitur $title akan segera hadir.', style: const TextStyle(fontSize: 16))),
    );
  }
}

class _StudentListView extends StatelessWidget {
  const _StudentListView();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> students = [
      {'nama': 'Anissa Vika', 'nis': '2413025005'},
      {'nama': 'Anita Rahmawati', 'nis': '2413025013'},
      {'nama': 'Khansa Nabila Hafish', 'nis': '2413025015'},
      {'nama': 'Syifa Nur R', 'nis': '2413025019'},
      {'nama': 'Elsa Susanti', 'nis': '2413025027'},
      {'nama': 'Raehan', 'nis': '2413025033'},
      {'nama': 'Selvia Alexandra', 'nis': '2413025025'},
      {'nama': 'Shava Phiyan', 'nis': '2413025047'},
      {'nama': 'Nur Istikomah', 'nis': '2413025053'},
      {'nama': 'Aulia Tri A', 'nis': '2413025073'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Siswa - XI-A3', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF2457C5).withOpacity(0.1),
                child: const Icon(Icons.person, color: Color(0xFF2457C5)),
              ),
              title: Text(students[index]['nama']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('NIS: ${students[index]['nis']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}