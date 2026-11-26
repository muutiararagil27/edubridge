
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF2457C5);

  Future<void> _editProfile(
    BuildContext context,
    String nama,
    String telepon,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final namaController = TextEditingController(text: nama);
    final teleponController = TextEditingController(text: telepon);

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profil Guru'),
        content: Column(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final namaBaru = namaController.text.trim();

              if (namaBaru.isEmpty) return;

              try {
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user.uid)
                    .set({
                  'nama': namaBaru,
                  'email': user.email,
                  'noTelepon': teleponController.text.trim(),
                  'role': 'guru',
                }, SetOptions(merge: true));

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menyimpan profil: $e')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    namaController.dispose();
    teleponController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Pengguna belum login.'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Gagal memuat profil guru.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data?.data() ?? {};

          final nama = data['nama']?.toString().isNotEmpty == true
              ? data['nama'].toString()
              : user.displayName ?? 'Guru';

          final telepon = data['noTelepon']?.toString() ?? '-';
          final email = user.email ?? '-';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xFFDCE7FF),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Guru EduBridge',
                      style: TextStyle(color: Colors.grey),
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
                Icons.school_outlined,
                'Jabatan',
                'Guru',
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _editProfile(
                    context,
                    nama,
                    telepon == '-' ? '' : telepon,
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Edit Profil',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
      ),
    );
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
          Icon(icon, color: primaryColor, size: 25),
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
}
