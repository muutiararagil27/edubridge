import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MassAttendanceScreen extends StatefulWidget {
  const MassAttendanceScreen({super.key});

  @override
  State<MassAttendanceScreen> createState() => _MassAttendanceScreenState();
}

class _MassAttendanceScreenState extends State<MassAttendanceScreen> {
  // Daftar 10 siswa yang disamakan dengan dashboard
  final List<Map<String, dynamic>> _students = [
    {'nama': 'Anissa Vika', 'nis': '2413025005', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Anita Rahmawati', 'nis': '2413025013', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Khansa Nabila Hafish', 'nis': '2413025015', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Syifa Nur R', 'nis': '2413025019', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Elsa Susanti', 'nis': '2413025027', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Raehan', 'nis': '2413025033', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Selvia Alexandra', 'nis': '2413025025', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Shava Phiyan', 'nis': '2413025047', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Nur Istikomah', 'nis': '2413025053', 'status': 'Hadir', 'keterangan': '-'},
    {'nama': 'Aulia Tri A', 'nis': '2413025073', 'status': 'Hadir', 'keterangan': '-'},
  ];

  bool _isLoading = false;

  Future<void> _simpanKehadiranMassal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final batch = FirebaseFirestore.instance.batch();

      for (var student in _students) {
        final docRef = FirebaseFirestore.instance.collection('Kehadiran').doc();
        batch.set(docRef, {
          'siswaId': student['nama'],
          'nis': student['nis'],
          'status': student['status'],
          'keterangan': student['keterangan'],
          'tanggal': DateTime.now().toString(),
          'guruId': 'guru_terlogin',
          'kelas': 'XI-A3',
        });
      }

      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kehadiran seluruh siswa XI-A3 berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Input Kehadiran XI-A3',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_students[index]['nama']} (${_students[index]['nis']})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          children: ['Hadir', 'Izin', 'Alpha'].map((status) {
                            return ChoiceChip(
                              label: Text(status),
                              selected: _students[index]['status'] == status,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _students[index]['status'] = status;
                                  });
                                }
                              },
                              selectedColor: const Color(0xFF2457C5).withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: _students[index]['status'] == status
                                    ? const Color(0xFF2457C5)
                                    : Colors.black,
                                fontWeight: _students[index]['status'] == status
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Keterangan tambahan (Opsional)',
                            hintStyle: TextStyle(fontSize: 14),
                            border: UnderlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            _students[index]['keterangan'] = value;
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _simpanKehadiranMassal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2457C5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'SIMPAN SEMUA KEHADIRAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}