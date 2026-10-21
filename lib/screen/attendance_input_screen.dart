import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceInputScreen extends StatefulWidget {
  const AttendanceInputScreen({super.key});

  @override
  State<AttendanceInputScreen> createState() => _AttendanceInputScreenState();
}

class _AttendanceInputScreenState extends State<AttendanceInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentNameController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedStatus = 'Hadir';
  String _selectedClass = 'PTI 24 A';
  bool _isSaving = false;

  final List<String> _statusOptions = ['Hadir', 'Izin', 'Sakit', 'Alpa'];

  @override
  void dispose() {
    _studentNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveAttendance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final name = _studentNameController.text.trim();
      final note = _noteController.text.trim();

      // Menyimpan data ke koleksi 'Kehadiran' di Firestore
      await FirebaseFirestore.instance.collection('Kehadiran').add({
        'siswaId': name, // Nama/ID siswa
        'guruId': 'guru_terlogin', // Nanti otomatis dari Firebase Auth
        'kelas': _selectedClass,
        'status': _selectedStatus, // Hadir, Izin, Sakit, atau Alpa
        'tanggal': FieldValue.serverTimestamp(),
        'keterangan': note.isEmpty ? '-' : note,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data kehadiran berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset form setelah berhasil simpan
      _studentNameController.clear();
      _noteController.clear();
      setState(() {
        _selectedStatus = 'Hadir';
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan kehadiran: $e'),
          backgroundColor: Colors.red,
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
        title: const Text('Input Kehadiran Siswa'),
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
                'Presensi Siswa',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Catat status kehadiran siswa secara digital.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              _buildLabel('Nama Siswa'),
              TextFormField(
                controller: _studentNameController,
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
                  DropdownMenuItem(value: 'PTI 24 A', child: Text('PTI 24 A')),
                  DropdownMenuItem(value: 'PTI 24 B', child: Text('PTI 24 B')),
                  DropdownMenuItem(value: 'PTI 24 C', child: Text('PTI 24 C')),
                ],
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _selectedClass = value);
                        }
                      },
              ),

              const SizedBox(height: 18),

              _buildLabel('Status Kehadiran'),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: _decoration('Pilih status'),
                items: _statusOptions
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _selectedStatus = value);
                        }
                      },
              ),

              const SizedBox(height: 18),

              _buildLabel('Keterangan (Opsional)'),
              TextFormField(
                controller: _noteController,
                decoration: _decoration('Contoh: Surat dokter terlampir'),
                maxLines: 2,
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveAttendance,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Kehadiran'),
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
        borderSide: const BorderSide(color: Color(0xFFE0E5EE)),
      ),
    );
  }
}