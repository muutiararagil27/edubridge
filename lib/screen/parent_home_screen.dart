import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          title: const Text(
            'Laporan Orang Tua',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          bottom: const TabBar(
            labelColor: Color(0xFF2457C5),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2457C5),
            tabs: [
              Tab(icon: Icon(Icons.grade), text: 'Nilai'),
              Tab(icon: Icon(Icons.event_available), text: 'Kehadiran'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NilaiTab(),
            _KehadiranTab(),
          ],
        ),
      ),
    );
  }
}

// Tab untuk Menampilkan Nilai
class _NilaiTab extends StatelessWidget {
  const _NilaiTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Nilai')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Belum ada data nilai dari Guru.'),
          );
        }

        final listNilai = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: listNilai.length,
          itemBuilder: (context, index) {
            final data = listNilai[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  data['siswaId'] ?? 'Siswa',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Mapel: ${data['mataPelajaran'] ?? '-'}\nCatatan: ${data['catatan'] ?? '-'}',
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2457C5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Nilai: ${data['nilai'] ?? 0}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2457C5),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Tab untuk Menampilkan Kehadiran
class _KehadiranTab extends StatelessWidget {
  const _KehadiranTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Kehadiran')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Belum ada data kehadiran dari Guru.'),
          );
        }

        final listKehadiran = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: listKehadiran.length,
          itemBuilder: (context, index) {
            final data = listKehadiran[index].data() as Map<String, dynamic>;
            final String status = data['status'] ?? 'Hadir';

            Color statusColor = Colors.green;
            if (status == 'Izin') statusColor = Colors.orange;
            if (status == 'Alpha') statusColor = Colors.red;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.person, color: statusColor),
                title: Text(
                  data['siswaId'] ?? 'Siswa',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Keterangan: ${data['keterangan'] ?? '-'}'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}