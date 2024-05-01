import 'package:flutter/material.dart'; // Mengimpor library Flutter Material untuk komponen UI
import 'dart:convert'; // Mengimpor library dart:convert untuk pemrosesan JSON

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter dengan widget MyApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transkrip Mahasiswa', // Judul aplikasi
      initialRoute: '/', // Rute awal aplikasi
      routes: {
        '/': (context) => TranskripNilai(), // Rute untuk tampilan TranskripNilai
        '/ipk': (context) => IPKPage(), // Rute untuk tampilan IPKPage
      },
    );
  }
}

class TranskripNilai extends StatefulWidget {
  @override
  _TranskripNilaiState createState() => _TranskripNilaiState();
}

class _TranskripNilaiState extends State<TranskripNilai> {
  List<dynamic> mataKuliah = []; // Variabel untuk menyimpan data mata kuliah
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

  @override
  void initState() {
    super.initState();
    _getTranskripData(); // Memuat data transkrip saat widget diinisialisasi
  }

  void _getTranskripData() {
    Map<String, dynamic> transkrip = jsonDecode(transkripJson); // Mendekode JSON menjadi Map

    setState(() {
      mataKuliah = transkrip['mata_kuliah']; // Mengisi daftar mata kuliah dari data transkrip
    });
  }

  double calculateIPK() {
    double totalSKS = 0;
    double totalBobot = 0;

    // Menghitung total SKS dan total bobot nilai
    for (var matkul in mataKuliah) {
      double sks = matkul['sks'];
      totalSKS += sks;

      String nilai = matkul['nilai'];
      double bobot = 0;

      // Mengonversi nilai huruf menjadi bobot numerik
      if (nilai == 'A') {
        bobot = 4.0;
      } else if (nilai == 'A-') {
        bobot = 3.7;
      } else if (nilai == 'B+') {
        bobot = 3.3;
      } else if (nilai == 'B') {
        bobot = 3.0;
      }
      totalBobot += (bobot * sks);
    }

    return totalBobot / totalSKS; // Menghitung IPK
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transkrip Nilai'), // Judul AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama: Adyatma Kevin Aryaputra Ramadhan',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'NPM: 22082010020',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Semester: 5',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Transkrip Nilai:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('No')), // Kolom No
                    DataColumn(label: Text('Kode Mata Kuliah')), // Kolom Kode Mata Kuliah
                    DataColumn(label: Text('Mata Kuliah')), // Kolom Mata Kuliah
                    DataColumn(label: Text('SKS')), // Kolom SKS
                    DataColumn(label: Text('Nilai')), // Kolom Nilai
                    DataColumn(label: Text('Semester')), // Kolom Semester
                  ],
                  rows: List.generate(mataKuliah.length, (index) {
                    var matkul = mataKuliah[index];
                    return DataRow(
                      cells: [
                        DataCell(Text((index + 1).toString())), // Sel No
                        DataCell(Text(matkul['kode'])), // Sel Kode Mata Kuliah
                        DataCell(Text(matkul['nama'])), // Sel Mata Kuliah
                        DataCell(Text(matkul['sks'].toString())), // Sel SKS
                        DataCell(Text(matkul['nilai'])), // Sel Nilai
                        DataCell(Text('5')), // Sel Semester (konstan 5)
                      ],
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  double ipk = calculateIPK(); // Menghitung IPK
                  Navigator.pushNamed(context, '/ipk', arguments: ipk.toStringAsFixed(2)); // Pindah ke halaman IPK dengan nilai IPK sebagai argumen
                },
                child: Text('Hitung IPK'), // Tombol untuk menghitung IPK
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IPKPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ipk = ModalRoute.of(context)?.settings.arguments as String?; // Mendapatkan nilai IPK dari argumen

    return Scaffold(
      appBar: AppBar(
        title: Text('IPK'), // Judul AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'IPK: ${ipk ?? ""}', // Menampilkan nilai IPK
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tombol untuk kembali ke halaman sebelumnya
              },
              child: Text('Kembali'), // Teks pada tombol kembali
            ),
          ],
        ),
      ),
    );
  }
}