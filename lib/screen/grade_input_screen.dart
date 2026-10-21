import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GradeInputScreen extends StatefulWidget {
  const GradeInputScreen({super.key});

  @override
  State<GradeInputScreen> createState() => _GradeInputScreenState();
}

class _GradeInputScreenState extends State<GradeInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _gradeController = TextEditingController();

  String _selectedClass = 'PTI 24 A';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  Future<void> _saveGrade() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final name = _nameController.text.trim();
      final subject = _subjectController.text.trim();
      final grade = double.parse(_gradeController.text.trim());

      // Sesuai SRD Bab 3.6.4 (Struktur Data Koleksi Nilai)
      await FirebaseFirestore.instance.collection('Nilai').add({
        'siswaId': name, // Sementara menggunakan nama sebagai ID agar mudah dites
        'guruId': 'guru_terlogin', // Nanti disesuaikan dengan ID sesi guru
        'mataPelajaran': subject,
        'jenisPenilaian': 'Tugas/Ujian', // Bisa Anda kembangkan dengan Dropdown baru
        'Nilai': grade, // Rentang 0-100
        'Tanggal': FieldValue.serverTimestamp(),
        'keterangan': 'Input dari kelas $_selectedClass',
      });

      if (!mounted) return;

      // Tampilkan pemberitahuan jika penyimpanan berhasil.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nilai siswa berhasil disimpan ke Firebase!'),
          backgroundColor: Colors.green,
        ),
      );

      // Kosongkan formulir setelah berhasil disimpan.
      _nameController.clear();
      _subjectController.clear();
      _gradeController.clear();

      setState(() {
        _selectedClass = 'PTI 24 A';
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan nilai: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 6),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Input Nilai Siswa'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Form Nilai Siswa',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masukkan identitas siswa dan nilai akademiknya.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              _buildLabel('Nama Siswa'),
              TextFormField(
                controller: _nameController,
                decoration: _decoration('Masukkan nama siswa'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama siswa wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _buildLabel('Kelas'),
              DropdownButtonFormField<String>(
                initialValue: _selectedClass,
                decoration: _decoration('Pilih kelas'),
                items: const [
                  DropdownMenuItem(
                    value: 'PTI 24 A',
                    child: Text('PTI 24 A'),
                  ),
                  DropdownMenuItem(
                    value: 'PTI 24 B',
                    child: Text('PTI 24 B'),
                  ),
                  DropdownMenuItem(
                    value: 'PTI 24 C',
                    child: Text('PTI 24 C'),
                  ),
                ],
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _selectedClass = value;
                          });
                        }
                      },
              ),

              const SizedBox(height: 18),

              _buildLabel('Mata Pelajaran'),
              TextFormField(
                controller: _subjectController,
                decoration: _decoration('Masukkan mata pelajaran'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mata pelajaran wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _buildLabel('Nilai (0–100)'),
              TextFormField(
                controller: _gradeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _decoration('Contoh: 85'),
                validator: (value) {
                  final grade = double.tryParse(value?.trim() ?? '');

                  if (grade == null) {
                    return 'Masukkan nilai yang valid';
                  }

                  if (grade < 0 || grade > 100) {
                    return 'Nilai harus antara 0 sampai 100';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveGrade,
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
                    _isSaving ? 'Menyimpan...' : 'Simpan Nilai',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2457C5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE0E5EE),
        ),
      ),
    );
  }
}