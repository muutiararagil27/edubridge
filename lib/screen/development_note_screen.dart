
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DevelopmentNoteScreen extends StatefulWidget {
  const DevelopmentNoteScreen({super.key});

  @override
  State<DevelopmentNoteScreen> createState() =>
      _DevelopmentNoteScreenState();
}

class _DevelopmentNoteScreenState extends State<DevelopmentNoteScreen> {
  static const Color primaryColor = Color(0xFF2457C5);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedStudent;
  String _selectedNis = '';
  String _selectedCategory = 'Akademik';
  bool _isSaving = false;

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

  final List<String> categories = [
    'Akademik',
    'Kedisiplinan',
    'Sikap dan Perilaku',
    'Sosial',
    'Keaktifan',
    'Lainnya',
  ];

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('CatatanPerkembangan')
          .add({
        'namaSiswa': _selectedStudent,
        'nis': _selectedNis,
        'kategori': _selectedCategory,
        'deskripsi': _noteController.text.trim(),
        'guruId': user.uid,
        'guruEmail': user.email,
        'waktuCatatan': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _noteController.clear();

      setState(() {
        _selectedStudent = null;
        _selectedNis = '';
        _selectedCategory = 'Akademik';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan perkembangan berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan catatan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Baru saja';

    final date = timestamp.toDate();

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Catatan Perkembangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // FORM CATATAN
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.edit_note,
                        color: primaryColor,
                        size: 28,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tambah Catatan Siswa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Nama Siswa',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
  initialValue: _selectedStudent,
                    isExpanded: true,
                    decoration: InputDecoration(
                      hintText: 'Pilih siswa',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: students.map((student) {
                      return DropdownMenuItem<String>(
                        value: student['nama'],
                        child: Text(student['nama']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final student = students.firstWhere(
                        (item) => item['nama'] == value,
                      );

                      setState(() {
                        _selectedStudent = value;
                        _selectedNis = student['nis']!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Silakan pilih siswa';
                      }
                      return null;
                    },
                  ),

                  if (_selectedStudent != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'NIS: $_selectedNis',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

                  const Text(
                    'Kategori Perkembangan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                 DropdownButtonFormField<String>(
  initialValue: _selectedCategory,
                    isExpanded: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Deskripsi Perkembangan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _noteController,
                    maxLines: 5,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText:
                          'Tuliskan perkembangan, prestasi, '
                          'atau hal yang perlu diperhatikan dari siswa...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deskripsi catatan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveNote,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        _isSaving ? 'Menyimpan...' : 'Simpan Catatan',
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
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Riwayat Catatan Perkembangan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // RIWAYAT CATATAN DARI FIREBASE
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('CatatanPerkembangan')
                .where(
                  'guruId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                )
                .orderBy('waktuCatatan', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Gagal memuat riwayat catatan.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final notes = snapshot.data?.docs ?? [];

              if (notes.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 45,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Belum ada catatan perkembangan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: notes.map((doc) {
                  final data = doc.data();

                  final nama = data['namaSiswa']?.toString() ?? '-';
                  final nis = data['nis']?.toString() ?? '-';
                  final kategori = data['kategori']?.toString() ?? '-';
                  final deskripsi =
                      data['deskripsi']?.toString() ?? '';

                  final timestamp =
                      data['waktuCatatan'] as Timestamp?;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFFDCE7FF),
                              child: Icon(
                                Icons.person,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'NIS: $nis',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Hapus catatan',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Hapus Catatan'),
                                    content: const Text(
                                      'Apakah kamu yakin ingin menghapus '
                                      'catatan ini?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                          dialogContext,
                                          false,
                                        ),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                          dialogContext,
                                          true,
                                        ),
                                        child: const Text(
                                          'Hapus',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('CatatanPerkembangan')
                                        .doc(doc.id)
                                        .delete();
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Gagal menghapus: $e'),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EFFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            kategori,
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          deskripsi,
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _formatDate(timestamp),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
