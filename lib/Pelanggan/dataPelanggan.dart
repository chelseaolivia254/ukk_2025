import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homePage.dart';

class PelangganBookListPage extends StatefulWidget {
  const PelangganBookListPage({super.key});

  @override
  _PelangganBookListPageState createState() => _PelangganBookListPageState();
}

class _PelangganBookListPageState extends State<PelangganBookListPage> {
  List<Map<String, dynamic>> pelanggan = [];

  @override
  void initState() {
    super.initState();
    fetchBook();
  }

  Future<void> fetchBook() async {
    final response = await Supabase.instance.client.from('Pelanggan').select();

    setState(() {
      pelanggan = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ListView.builder(
        itemCount: pelanggan.length,
        itemBuilder: (context, index) {
          final book = pelanggan[index];
          return Card(
            color: Colors.blue[50],
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(book['NamaPelanggan'] ?? 'Nama tidak tersedia'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['Alamat'] ?? 'Alamat tidak tersedia',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                  Text(
                    book['NomorTelepon'] ?? 'Nomor telepon tidak tersedia',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Tambahkan logika navigasi ke halaman edit
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await Supabase.instance.client
                          .from('Pelanggan')
                          .delete()
                          .eq('PelangganID', book['PelangganID']);
                      fetchBook(); // Refresh data setelah menghapus
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PelangganBookListPage()),
          );
          if (result == true) {
            fetchBook(); // Refresh data jika pelanggan berhasil ditambahkan
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
