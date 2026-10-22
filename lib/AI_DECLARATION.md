# Deklarasi Penggunaan AI (AI Declaration) - EduBridge

Dokumen ini disusun sebagai bentuk transparansi penggunaan teknologi *Artificial Intelligence* (AI) dalam pengembangan proyek aplikasi UTS **EduBridge**.

## 1. Daftar Alat (AI Tools) yang Digunakan
* **Gemini (Google)**: Digunakan sebagai kolaborator utama untuk membantu perancangan struktur kode UI, logika state management Flutter, serta integrasi Cloud Firestore.
* **GitHub Copilot / VS Code AI Extension**: Digunakan untuk melengkapi baris kode (*autocompletion*) secara cepat.

## 2. Pembagian Peran (AI vs Manual)
* **Modul yang Dibantu AI**:
  * Perancangan kerangka dasar UI/UX untuk *Dashboard Guru* dan *Dashboard Orang Tua*.
  * Pembuatan struktur kode boilerplate untuk *ListView.builder*, *Card*, dan *StreamBuilder* Firebase.
  * Penulisan fungsi logika *batch commit* pada fitur absensi massal.
* **Modul yang Murni Ditulis/Disesuaikan Manual**:
  * Penyesuaian data 10 siswa spesifik kelas XI-A3 beserta NIS masing-masing sesuai kebutuhan studi kasus.
  * Penataan alur navigasi (`BottomNavigationBar`) serta penyesuaian teks dan *routing* halaman detail informasi akademik.
  * Proses pengujian (*testing*), *debugging* error, dan penyesuaian *state* aplikasi secara langsung di lingkungan lokal.

## 3. Studi Kasus Prompting (Contoh Instruksi dan Penyesuaian)
Berikut adalah contoh riwayat instruksi (*prompting*) dan penyesuaian logika manual yang dilakukan agar aplikasi berjalan stabil:

* **Contoh Kasus 1: Input Kehadiran Massal**
  * **Prompt Awal ke AI**: *"Tolong buatkan halaman input kehadiran massal untuk daftar siswa kelas XI-A3 yang terhubung ke Firebase Firestore."*
  * **Hasil Awal AI**: AI memberikan fungsi dasar menggunakan perulangan *batch* Firestore dengan data siswa tiruan umum.
  * **Penyesuaian Manual**: Pengembang menyesuaikan daftar nama dan nomor induk siswa (*NIS*) agar persis memuat 10 orang siswa riil kelas XI-A3, serta menambahkan indikator *loading* agar tombol tidak diklik ganda saat proses penyimpanan data berlangsung.

* **Contoh Kasus 2: Navigasi Antar Halaman**
  * **Prompt Awal ke AI**: *"Kenapa tombol navigasi bawah di beranda guru tidak bisa dipencet setelah diubah?"*
  * **Hasil Awal AI**: AI memberikan penjelasan mengenai perubahan dari `StatelessWidget` ke `StatefulWidget` serta instruksi melakukan *Hot Restart*.
  * **Penyesuaian Manual**: Pengembang menerapkan perubahan struktur kelas tersebut dan melakukan *Hot Restart* secara berkala untuk memastikan state perpindahan tab berjalan responsif.