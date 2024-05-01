import 'package:flutter/material.dart';  // Impor library dasar Flutter untuk membangun antarmuka pengguna.
import 'package:http/http.dart' as http;  // Impor package http untuk melakukan permintaan HTTP.
import 'dart:convert';  // Impor library dart:convert untuk mengonversi data JSON.
import 'package:url_launcher/url_launcher.dart';  // Impor package url_launcher untuk membuka tautan web.

class Universitas {
  final String nama;  // Variabel untuk menyimpan nama universitas.
  final String situs;  // Variabel untuk menyimpan URL situs web universitas.

  Universitas({required this.nama, required this.situs});  // Konstruktor untuk membuat instance Universitas.

  factory Universitas.fromJson(Map<String, dynamic> json) {  // Factory method untuk membuat instance Universitas dari data JSON.
    return Universitas(
      nama: json['name'] ?? 'Nama Tidak Tersedia',  // Mendapatkan nama universitas dari data JSON atau mengatur nilai default jika tidak tersedia.
      situs: json['web_pages'] != null && json['web_pages'].isNotEmpty  // Mendapatkan URL situs web universitas dari data JSON atau mengatur nilai default jika tidak tersedia.
          ? json['web_pages'][0]
          : 'Website Tidak Tersedia',
    );
  }
}

class UniversitasList extends StatefulWidget {  // Kelas widget stateful untuk menampilkan daftar universitas.
  @override
  _UniversitasListState createState() => _UniversitasListState();  // Membuat instance dari state untuk widget UniversitasList.
}

class _UniversitasListState extends State<UniversitasList> {  // Kelas state untuk menangani status dan interaksi widget UniversitasList.
  late Future<List<Universitas>> _universitasListFuture;  // Variabel untuk menyimpan future yang berisi daftar universitas.

  @override
  void initState() {  // Metode initState dipanggil ketika state pertama kali dibuat.
    super.initState();
    _universitasListFuture = _fetchUniversitasList();  // Memuat daftar universitas saat initState dipanggil.
  }

  Future<List<Universitas>> _fetchUniversitasList() async {  // Metode untuk mengambil data daftar universitas dari server.
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));  // Melakukan permintaan GET ke API untuk mendapatkan data universitas.

    if (response.statusCode == 200) {  // Memeriksa apakah permintaan berhasil.
      final List<dynamic> data = json.decode(response.body);  // Mendekode respons JSON menjadi list of maps.
      return data.map((json) => Universitas.fromJson(json)).toList();  // Mengonversi setiap map menjadi instance Universitas dan mengembalikan daftar universitas.
    } else {
      throw Exception('Failed to fetch universitas');  // Melemparkan pengecualian jika gagal mengambil data.
    }
  }

  @override
  Widget build(BuildContext context) {  // Metode build untuk membangun antarmuka pengguna.
    return FutureBuilder<List<Universitas>>(  // Widget FutureBuilder untuk menampilkan widget berdasarkan status future.
      future: _universitasListFuture,  // Mengatur future yang digunakan oleh FutureBuilder.
      builder: (context, snapshot) {  // Builder untuk membangun UI berdasarkan status future.
        if (snapshot.connectionState == ConnectionState.waiting) {  // Memeriksa jika future sedang dalam status tunggu.
          return Center(  // Widget Center untuk menengahkan widget.
            child: CircularProgressIndicator(),  // Menampilkan indikator loading.
          );
        } else if (snapshot.hasError) {  // Memeriksa jika ada kesalahan dalam mengambil data.
          return Text('Error: ${snapshot.error}');  // Menampilkan pesan kesalahan.
        } else if (snapshot.hasData) {  // Memeriksa jika data telah diterima.
          final universitasList = snapshot.data!;  // Mendapatkan daftar universitas dari snapshot.
          return ListView.builder(  // Widget ListView.builder untuk menampilkan daftar universitas dalam bentuk daftar gulir.
            itemCount: universitasList.length,  // Mengatur jumlah item dalam daftar.
            itemBuilder: (context, index) {  // Builder untuk membuat setiap item dalam daftar.
              final universitas = universitasList[index];  // Mendapatkan instance Universitas untuk item saat ini.
              return ListTile(  // Widget ListTile untuk menampilkan setiap item dalam daftar.
                title: Text(universitas.nama),  // Menampilkan nama universitas sebagai judul.
                subtitle: Text(universitas.situs),  // Menampilkan URL situs web universitas sebagai subjudul.
                onTap: () {  // Menangani ketika item di-tap.
                  launch(universitas
                      .situs); // Menggunakan package url_launcher untuk membuka tautan web universitas.
                },
              );
            },
          );
        } else {
          return Text('No data found');  // Menampilkan pesan jika tidak ada data yang ditemukan.
        }
      },
    );
  }
}

void main() {  // Metode main untuk menjalankan aplikasi Flutter.
  runApp(MaterialApp(  // Menjalankan aplikasi Flutter menggunakan MaterialApp sebagai root widget.
    home: Scaffold(  // Menggunakan Scaffold sebagai root widget untuk menampilkan halaman.
      appBar: AppBar(  // AppBar sebagai bagian atas halaman untuk menampilkan judul.
        title: Text('Daftar Universitas'),  // Menampilkan judul halaman.
      ),
      body: UniversitasList(),  // Menampilkan widget UniversitasList sebagai konten halaman.
    ),
  ));
}
