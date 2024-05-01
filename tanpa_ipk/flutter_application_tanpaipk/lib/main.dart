import 'package:flutter/material.dart'; // Mengimpor library Flutter Material untuk komponen UI
import 'dart:convert'; // Mengimpor library dart:convert untuk pemrosesan JSON

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transkrip Mahasiswa', // Menetapkan judul aplikasi
      home: Scaffold(
        appBar: AppBar(
          title: Text('Transkrip Mahasiswa'), // Menetapkan judul AppBar
        ),
        body: TranskripMahasiswa(), // Menampilkan widget TranskripMahasiswa di dalam body Scaffold
      ),
    );
  }
}

class TranskripMahasiswa extends StatelessWidget {

  // Fungsi untuk mengubah nilai huruf menjadi angka
  double _nilaiToNumber(String nilai) {
    switch (nilai) {
      case 'A': return 4.0;
      case 'A-': return 3.7;
      case 'B+': return 3.3;
      case 'B': return 3.0;
      case 'C+': return 2.7;
      case 'C': return 2.3;
      case 'C-': return 2.0;
      // tambahkan case untuk nilai lain jika diperlukan
      default: return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // JSON transkrip mahasiswa
    String transkripJson = '''
    {
      "nama": "Adyatma Kevin Aryaputra Ramadhan",
      "NIM": "22082010020",
      "semester": 5,
      "mata_kuliah": [
        {"kode": "MK101", "nama": "Pemrograman Lanjut", "sks": 3, "nilai": "A"},
        {"kode": "MK102", "nama": "Basis Data", "sks": 4, "nilai": "B+"},
        {"kode": "MK103", "nama": "Sistem Operasi", "sks": 3, "nilai": "A-"},
        {"kode": "MK104", "nama": "Jaringan Komputer", "sks": 3, "nilai": "B"},
        {"kode": "MK601", "nama": "Kewirausahaan", "sks": 3, "nilai": "A-"},
        {"kode": "MK106", "nama": "Manajemen Proyek Sistem Informasi", "sks": 3, "nilai": "A"},
        {"kode": "MK107", "nama": "Audit", "sks": 3, "nilai": "A-"},
        {"kode": "MK108", "nama": "Metode Penelitian", "sks": 3, "nilai": "A-"}
      ]
    }
    ''';

    // Mengubah JSON menjadi Map
    Map<String, dynamic> transkrip = jsonDecode(transkripJson);

    // Mendapatkan data dari Map
    String nama = transkrip['nama'];
    String NIM = transkrip['NIM'];
    int semester = transkrip['semester'];
    List<dynamic> mataKuliah = transkrip['mata_kuliah'];

    // Membuat List<DataRow> untuk setiap mata kuliah
    List<DataRow> rows = [];
    for (var i = 0; i < mataKuliah.length; i++) {
      var matkul = mataKuliah[i];
      rows.add(DataRow(
        cells: [
          DataCell(Text((i + 1).toString())), // Sel untuk nomor
          DataCell(Text(matkul['kode'])), // Sel untuk kode mata kuliah
          DataCell(Text(matkul['nama'])), // Sel untuk nama mata kuliah
          DataCell(Text(matkul['sks'].toString())), // Sel untuk SKS
          DataCell(Text(matkul['nilai'])), // Sel untuk nilai
          DataCell(Text(semester.toString())), // Sel untuk semester
        ],
      ));
    }

    // Widget tabel
    Widget table = DataTable(
      columns: [
        DataColumn(label: Text('No')), // Kolom untuk nomor
        DataColumn(label: Text('Kode Mata Kuliah')), // Kolom untuk kode mata kuliah
        DataColumn(label: Text('Mata Kuliah')), // Kolom untuk nama mata kuliah
        DataColumn(label: Text('SKS')), // Kolom untuk SKS
        DataColumn(label: Text('Nilai')), // Kolom untuk nilai
        DataColumn(label: Text('Semester')), // Kolom untuk semester
      ],
      rows: rows, // Baris-baris tabel
    );

    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ratakan teks ke kiri
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0), // Padding kiri
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Ratakan teks ke kiri
                children: [
                  Text(
                    'Nama: $nama', // Teks untuk nama mahasiswa
                    style: TextStyle(fontSize: 20), // Gaya teks
                  ),
                  Text(
                    'NIM: $NIM', // Teks untuk NIM mahasiswa
                    style: TextStyle(fontSize: 20), // Gaya teks
                  ),
                  Text(
                    'Semester: $semester', // Teks untuk semester
                    style: TextStyle(fontSize: 20), // Gaya teks
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Spasi vertikal
            Padding(
              padding: const EdgeInsets.only(left: 20.0), // Padding kiri
              child: Text(
                'Transkrip Nilai:', // Teks untuk transkrip nilai
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Gaya teks
              ),
            ),
            SizedBox(height: 10), // Spasi vertikal
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Scroll horizontal untuk tabel
              child: table, // Tampilkan tabel
            ),
          ],
        ),
      ),
    );
  }
}
