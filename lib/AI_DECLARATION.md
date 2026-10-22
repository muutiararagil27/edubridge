# Catatan Penggunaan AI & Transparansi Proyek - EduBridge

Dokumen ini saya buat untuk menjelaskan bagaimana saya memanfaatkan bantuan teknologi *Artificial Intelligence* (AI) selama proses ngoding dan pengerjaan aplikasi UTS **EduBridge** ini.

## 1. Tool AI yang Saya Pakai
* **Gemini (Google)**: Saya pakai sebagai teman diskusi utama buat ngebantu nyusun struktur UI Flutter, nulis logika dasar *state management*, dan nyambungin ke Cloud Firestore.
* **VS Code AI/Copilot**: Sesekali dipakai buat *autocompletion* baris kode biar lebih cepat.

## 2. Bagian Mana yang Dibantu AI vs Dikerjakan Sendiri?
* **Bagian yang Dibantu AI**:
  * Bikin kerangka awal atau *boilerplate code* untuk tampilan *Card*, *ListView*, dan struktur dasar halaman dashboard guru & orang tua.
  * Ngebantu nulis logika *batch commit* buat fitur absensi massal di Firebase biar lebih efisien.
* **Bagian yang Saya Kerjakan & Sesuaikan Sendiri**:
  * Nyesuaiin daftar 10 nama siswa dan NIS kelas XI-A3 secara spesifik sesuai studi kasus.
  * Ngerapihin navigasi tombol (`BottomNavigationBar`) dan routing halaman detail akademik biar pas diklik datanya beneran muncul sesuai akun.
  * Proses *debugging*, benerin error kodingan, *testing* langsung di emulator/browser, dan *push* commit secara berkala ke GitHub.

## 3. Contoh Proses Tanya Jawab (Prompting) & Penyesuaian
Selama pengerjaan, saya aktif bolak-balik konsultasi sama AI. Berikut contoh kendala yang saya tanyain dan cara saya nyesuaiin kodenya:

* **Kasus 1: Bikin Form Absensi Massal**
  * **Pertanyaan ke AI**: *"Tolong buatkan halaman input kehadiran massal untuk daftar siswa kelas XI-A3 yang terhubung ke Firebase Firestore."*
  * **Hasil dari AI**: AI ngasih fungsi perulangan dasar dengan data dummy umum.
  * **Penyesuaian Saya**: Saya ubah datanya supaya pas nampilin 10 siswa asli kelas XI-A3, terus saya tambahin tombol simpan supaya datanya beneran masuk ke database Firebase saya.

* **Kasus 2: Memperbaiki Navigasi Menu Detail Orang Tua**
  * **Pertanyaan ke AI**: *"Kenapa menu informasi akademik di dashboard orang tua pas dipencet masih kosong/placeholder?"*
  * **Hasil dari AI**: AI nyaranin buat misahin *class* baru khusus nampilin detail data akademik.
  * **Penyesuaian Saya**: Saya terapin kodenya, terus saya isi *mock data* nilai dan kehadiran atas nama Syifa Nur R supaya waktu didemokan aplikasinya kelihatan hidup dan ada isinya.