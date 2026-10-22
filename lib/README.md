# EduBridge - Aplikasi Penghubung Sekolah & Orang Tua

Halo! Proyek ini saya buat buat nyelesaiin tugas UTS mata kuliah pengembangan aplikasi mobile. **EduBridge** adalah aplikasi berbasis Flutter yang saya rancang untuk ngebantu komunikasi dan pemantauan kegiatan antara guru dan orang tua siswa, khususnya buat kelas **XI-A3**.

## Fitur yang Udah Berhasil Dibuat
* **Dashboard Guru**: 
  * Nampilin daftar 10 siswa spesifik kelas XI-A3 lengkap sama NIS masing-masing.
  * Fitur input nilai siswa yang udah terhubung langsung ke Firebase Firestore.
  * Fitur absensi/kehadiran massal biar guru gak perlu ngecek satu-satu secara manual.
* **Dashboard Orang Tua**:
  * Tampilan *gradient* biru yang rapi dan interaktif khusus buat akun orang tua (diuji coba pakai data siswa atas nama *Syifa Nur R*).
  * Menu informasi akademik lengkap yang bisa diklik buat ngecek Hasil Studi (nilai), Riwayat Kehadiran, Catatan dari Wali Kelas, sampai Tagihan Sekolah.

## Teknologi yang Digunakan
* **Frontend**: Flutter (Dart)
* **Backend & Database**: Firebase Authentication & Cloud Firestore

## Cara Menjalankan Aplikasi
1. Clone dulu repository ini ke laptop kamu.
2. Buka terminal di folder proyek, terus jalankan perintah:
   ```bash
   flutter pub get