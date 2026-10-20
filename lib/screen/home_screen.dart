import 'package:flutter/material.dart';
import 'report_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: Column(
              children: [
                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    25,
                    20,
                    25,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3155D9),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Orang Tua 👋',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Pantau perkembangan belajar Ananda',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // ISI
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DATA SISWA
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                Colors.blue.withValues(alpha: 0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8EDFF),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF3155D9),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ananda',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Kelas XI • Teknik Komputer dan Jaringan',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Perkembangan Belajar
                        const Text(
                          'Perkembangan Belajar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          '21 - 27 September 2026',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // NILAI DAN KEHADIRAN
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.school_outlined,
                                title: 'Nilai',
                                value: '87',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.calendar_today_outlined,
                                title: 'Kehadiran',
                                value: '95%',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // PROGRESS AKADEMIK
                        _ProgressCard(
                          title: 'Akademik',
                          value: '87%',
                          progress: 0.87,
                        ),

                        const SizedBox(height: 12),

                        // PROGRESS PRAKTIK
                        _ProgressCard(
                          title: 'Praktik',
                          value: '80%',
                          progress: 0.80,
                        ),

                        const SizedBox(height: 18),

                        // CATATAN GURU
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.notes_outlined,
                                    color: Color(0xFF3155D9),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Catatan Guru',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Ananda menunjukkan perkembangan yang baik dalam pembelajaran minggu ini.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BOTTOM NAVIGATION
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        active: true,
                        onTap: () {},
                      ),

                      _NavItem(
                        icon: Icons.assessment_outlined,
                        label: 'Report',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ReportScreen(),
                            ),
                          );
                        },
                      ),

                      _NavItem(
                        icon: Icons.chat_bubble_outline,
                        label: 'Chat',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ChatScreen(),
                            ),
                          );
                        },
                      ),

                      _NavItem(
                        icon: Icons.person_outline,
                        label: 'Profil',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// =========================
// STAT CARD
// =========================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF3155D9),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


// =========================
// PROGRESS CARD
// =========================

class _ProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final double progress;

  const _ProgressCard({
    required this.title,
    required this.value,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF3155D9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: const Color(0xFFE8EDFF),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF3155D9),
            ),
          ),
        ],
      ),
    );
  }
}


// =========================
// BOTTOM NAV ITEM
// =========================

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active
                  ? const Color(0xFF3155D9)
                  : Colors.grey,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: active
                    ? const Color(0xFF3155D9)
                    : Colors.grey,
                fontWeight: active
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}