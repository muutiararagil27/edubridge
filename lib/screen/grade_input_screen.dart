
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _saveGrade() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final subject = _subjectController.text.trim();
    final grade = double.parse(_gradeController.text.trim());

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nilai Berhasil Diinput'),
        content: Text(
          'Nama: $name\n'
          'Kelas: $_selectedClass\n'
          'Mata Pelajaran: $subject\n'
          'Nilai: $grade\n\n'
          'Catatan: data ini belum disimpan ke database.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
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
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Nama siswa wajib diisi'
                        : null,
              ),
              const SizedBox(height: 18),
              _buildLabel('Kelas'),
              DropdownButtonFormField<String>(
                value: _selectedClass,
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
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedClass = value);
                  }
                },
              ),
              const SizedBox(height: 18),
              _buildLabel('Mata Pelajaran'),
              TextFormField(
                controller: _subjectController,
                decoration: _decoration('Masukkan mata pelajaran'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Mata pelajaran wajib diisi'
                        : null,
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
                  if (grade == null) return 'Masukkan nilai yang valid';
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
                  onPressed: _saveGrade,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan Nilai'),
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
