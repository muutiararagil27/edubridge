import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _ParentDashboardView(),
    const _PlaceholderScreen(title: 'Jadwal Pelajaran'),
    const _PlaceholderScreen(title: 'Pesan / Chat Guru'),
    const _PlaceholderScreen(title: 'Profil Orang Tua'),
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
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

class _ParentDashboardView extends StatelessWidget {
  const _ParentDashboardView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Dashboard Orang Tua', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Orang tua dari: Syifa Nur R (XI-A3)', style: TextStyle(color: Colors.black54, fontSize: 16)),
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2457C5), Color(0xFF4A7CEB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 24,
                    child: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Syifa Nur R', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('NIS: 2413025019', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Tingkat Kehadiran Bulan Ini: 100%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(value: 1.0, backgroundColor: Colors.white24, color: Colors.greenAccent, minHeight: 6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        const Text('Informasi Akademik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        
        _menuCard(
          context,
          icon: Icons.assignment_turned_in_outlined, title: 'Hasil Studi (Nilai)', subtitle: 'Lihat nilai UTS dan rapor', color: Colors.blue,
        ),
        _menuCard(
          context,
          icon: Icons.event_available_outlined, title: 'Riwayat Kehadiran', subtitle: 'Pantau presensi harian Syifa', color: Colors.green,
        ),
        _menuCard(
          context,
          icon: Icons.notifications_active_outlined, title: 'Catatan Guru', subtitle: 'Pesan dan evaluasi dari wali kelas', color: Colors.orange,
        ),
        _menuCard(
          context,
          icon: Icons.account_balance_wallet_outlined, title: 'Tagihan Sekolah', subtitle: 'Informasi administrasi keuangan', color: Colors.purple,
        ),
      ],
    );
  }

  Widget _menuCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color}) {
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
        onTap: () {
          // Diarahkan langsung ke halaman detail isi data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _DetailInfoScreen(title: title),
            ),
          );
        },
      ),
    );
  }
}

class _DetailInfoScreen extends StatelessWidget {
  final String title;
  const _DetailInfoScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> details = [];

    if (title.contains('Nilai')) {
      details = [
        {'sub': 'Matematika', 'val': '88 (A-)'},
        {'sub': 'Bahasa Indonesia', 'val': '92 (A)'},
        {'sub': 'Bahasa Inggris', 'val': '85 (B+)'},
        {'sub': 'Ilmu Pengetahuan Alam', 'val': '90 (A)'},
      ];
    } else if (title.contains('Kehadiran')) {
      details = [
        {'sub': 'Senin, 20 Okt 2026', 'val': 'Hadir'},
        {'sub': 'Selasa, 21 Okt 2026', 'val': 'Hadir'},
        {'sub': 'Rabu, 22 Okt 2026', 'val': 'Hadir'},
      ];
    } else if (title.contains('Catatan')) {
      details = [
        {'sub': 'Wali Kelas (XI-A3)', 'val': 'Syifa aktif dan rajin mengikuti kegiatan diskusi kelas.'},
      ];
    } else {
      details = [
        {'sub': 'SPP Bulan Oktober', 'val': 'Lunas'},
        {'sub': 'Uang Kegiatan', 'val': 'Lunas'},
      ];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: details.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(details[index]['sub']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(
                details[index]['val']!,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2457C5), fontSize: 15),
              ),
            ),
          );
        },
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