import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              'Orang Tua',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 25),

          _profileItem(
            Icons.person_outline,
            'Data Orang Tua',
          ),

          _profileItem(
            Icons.child_care_outlined,
            'Data Ananda',
          ),

          _profileItem(
            Icons.settings_outlined,
            'Pengaturan',
          ),

          _profileItem(
            Icons.logout,
            'Keluar',
          ),
        ],
      ),
    );
  }

  Widget _profileItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF3155D9),
        ),
        title: Text(title),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }
}