
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import '../guru_chat_page.dart';

const Color primaryColor = Color(0xFF2457C5);
const Color backgroundColor = Color(0xFFF5F7FB);

// =====================================================
// PARENT HOME SCREEN
// =====================================================

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const _ParentDashboardView(),
    const _ScheduleScreen(),
    const GuruChatPage(),
    const _ParentProfileScreen(),
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'EduBridge',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: _logout,
          ),
        ],
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// =====================================================
// DASHBOARD ORANG TUA
// =====================================================

class _ParentDashboardView extends StatelessWidget {
  const _ParentDashboardView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Dashboard Orang Tua',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Selamat datang di EduBridge!',
          style: TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 24),

        // KARTU INFORMASI SISWA
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                primaryColor,
                Color(0xFF4A7CEB),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Syifa Nur R',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'NIS: 2413025019',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Kelas XI-A3',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 22),

              Text(
                'Pantau perkembangan akademik anak Anda melalui EduBridge.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Informasi Akademik',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 14),

        _dashboardMenu(
          context,
          icon: Icons.assignment_outlined,
          title: 'Hasil Studi',
          subtitle: 'Lihat informasi nilai siswa',
          color: Colors.blue,
          page: const _DetailInfoScreen(
            title: 'Hasil Studi',
          ),
        ),

        _dashboardMenu(
          context,
          icon: Icons.event_available_outlined,
          title: 'Riwayat Kehadiran',
          subtitle: 'Pantau kehadiran siswa',
          color: Colors.green,
          page: const _DetailInfoScreen(
            title: 'Riwayat Kehadiran',
          ),
        ),

        _dashboardMenu(
          context,
          icon: Icons.sticky_note_2_outlined,
          title: 'Catatan Guru',
          subtitle: 'Lihat catatan perkembangan siswa',
          color: Colors.orange,
          page: const _DetailInfoScreen(
            title: 'Catatan Guru',
          ),
        ),

        _dashboardMenu(
          context,
          icon: Icons.calendar_month_outlined,
          title: 'Jadwal Pelajaran',
          subtitle: 'Lihat jadwal kegiatan belajar',
          color: Colors.purple,
          page: const _ScheduleScreen(),
        ),
      ],
    );
  }

  Widget _dashboardMenu(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
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
          backgroundColor: color.withOpacity(0.12),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// DETAIL INFORMASI AKADEMIK
// =====================================================

class _DetailInfoScreen extends StatelessWidget {
  final String title;

  const _DetailInfoScreen({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> details = [];

    if (title == 'Hasil Studi') {
      details = [
        {'sub': 'Matematika', 'val': '88'},
        {'sub': 'Bahasa Indonesia', 'val': '92'},
        {'sub': 'Bahasa Inggris', 'val': '85'},
        {'sub': 'Ilmu Pengetahuan Alam', 'val': '90'},
      ];
    } else if (title == 'Riwayat Kehadiran') {
      details = [
        {'sub': 'Senin, 20 Oktober 2026', 'val': 'Hadir'},
        {'sub': 'Selasa, 21 Oktober 2026', 'val': 'Hadir'},
        {'sub': 'Rabu, 22 Oktober 2026', 'val': 'Hadir'},
      ];
    } else {
      details = [
        {
          'sub': 'Catatan Wali Kelas',
          'val': 'Syifa aktif dan rajin mengikuti kegiatan diskusi kelas.',
        },
      ];
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: details.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                details[index]['sub']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(details[index]['val']!),
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// JADWAL PELAJARAN
// =====================================================

class _ScheduleScreen extends StatelessWidget {
  const _ScheduleScreen();

  static const List<Map<String, String>> schedule = [
    {
      'hari': 'Senin',
      'jam': '07.30 - 09.00',
      'mapel': 'Matematika',
      'guru': 'Guru Matematika',
    },
    {
      'hari': 'Senin',
      'jam': '09.15 - 10.45',
      'mapel': 'Bahasa Indonesia',
      'guru': 'Guru Bahasa Indonesia',
    },
    {
      'hari': 'Selasa',
      'jam': '07.30 - 09.00',
      'mapel': 'Bahasa Inggris',
      'guru': 'Guru Bahasa Inggris',
    },
    {
      'hari': 'Selasa',
      'jam': '09.15 - 10.45',
      'mapel': 'IPA',
      'guru': 'Guru IPA',
    },
    {
      'hari': 'Rabu',
      'jam': '07.30 - 09.00',
      'mapel': 'Matematika',
      'guru': 'Guru Matematika',
    },
    {
      'hari': 'Kamis',
      'jam': '07.30 - 09.00',
      'mapel': 'Bahasa Indonesia',
      'guru': 'Guru Bahasa Indonesia',
    },
    {
      'hari': 'Jumat',
      'jam': '07.30 - 09.00',
      'mapel': 'Bahasa Inggris',
      'guru': 'Guru Bahasa Inggris',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Jadwal Pelajaran',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Jadwal kegiatan belajar siswa kelas XI-A3',
          style: TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 20),

        ...days.map((day) {
          final dailySchedule = schedule
              .where((item) => item['hari'] == day)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 10),

              ...dailySchedule.map((item) {
                return Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFDCE7FF),
                      child: Icon(
                        Icons.menu_book,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      item['mapel']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(item['guru']!),
                    trailing: Text(
                      item['jam']!,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),
            ],
          );
        }),
      ],
    );
  }
}

// =====================================================
// PROFIL ORANG TUA
// =====================================================

class _ParentProfileScreen extends StatelessWidget {
  const _ParentProfileScreen();

  Future<void> _editProfile(
    BuildContext context,
    String nama,
    String telepon,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final namaController = TextEditingController(text: nama);
    final teleponController = TextEditingController(text: telepon);

    try {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Edit Profil Orang Tua'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: teleponController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Batal'),
              ),

              ElevatedButton(
                onPressed: () async {
                  if (namaController.text.trim().isEmpty) return;

                  try {
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .set({
                      'nama': namaController.text.trim(),
                      'email': user.email,
                      'noTelepon': teleponController.text.trim(),
                      'role': 'orang_tua',
                    }, SetOptions(merge: true));

                    if (!dialogContext.mounted) return;

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Profil berhasil diperbarui!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    if (!dialogContext.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menyimpan profil: $e'),
                      ),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );
    } finally {
      namaController.dispose();
      teleponController.dispose();
    }
  }

  Widget _profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 25,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Pengguna belum login.'),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Gagal memuat profil: ${snapshot.error}',
            ),
          );
        }

        final data = snapshot.data?.data() ?? {};

        final nama = data['nama']?.toString().isNotEmpty == true
            ? data['nama'].toString()
            : 'Orang Tua';

        final telepon = data['noTelepon']?.toString() ?? '-';
        final email = user.email ?? '-';

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),

            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFDCE7FF),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: primaryColor,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Profil Orang Tua',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Informasi Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _profileItem(
              Icons.person_outline,
              'Nama Lengkap',
              nama,
            ),

            _profileItem(
              Icons.email_outlined,
              'Email',
              email,
            ),

            _profileItem(
              Icons.phone_outlined,
              'Nomor Telepon',
              telepon,
            ),

            _profileItem(
              Icons.child_care,
              'Nama Anak',
              'Syifa Nur R',
            ),

            _profileItem(
              Icons.school_outlined,
              'Kelas',
              'XI-A3',
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _editProfile(
                    context,
                    nama,
                    telepon == '-' ? '' : telepon,
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
