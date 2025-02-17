import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Halaman Utama untuk Menampilkan Daftar Pelanggan
class PelangganBookListPage extends StatefulWidget {
  const PelangganBookListPage({Key? key}) : super(key: key);

  @override
  _PelangganBookListPageState createState() => _PelangganBookListPageState();
}

class _PelangganBookListPageState extends State<PelangganBookListPage> {
  List<Map<String, dynamic>> pelanggan = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  // Fungsi untuk mengambil data pelanggan dari Supabase
  Future<void> fetchPelanggan() async {
    try {
      final response = await Supabase.instance.client.from('Pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Daftar Pelanggan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: pelanggan.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pelanggan.length,
              itemBuilder: (context, index) {
                final customer = pelanggan[index];
                return Card(
                  color: Colors.blue[50],
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(customer['NamaPelanggan'] ?? 'Nama tidak tersedia'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer['Alamat'] ?? 'Alamat tidak tersedia',
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                        Text(
                          customer['NomorTelepon'] ?? 'Nomor telepon tidak tersedia',
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
                            // Tambahkan logika untuk navigasi ke halaman edit pelanggan
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Hapus pelanggan dari database Supabase
                            await Supabase.instance.client
                                .from('Pelanggan')
                                .delete()
                                .eq('PelangganID', customer['PelangganID']);
                            fetchPelanggan(); // Refresh data setelah penghapusan
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
            MaterialPageRoute(builder: (context) => PelangganAddPage()),
          );
          if (result == true) {
            fetchPelanggan(); // Refresh data jika pelanggan berhasil ditambahkan
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Halaman untuk Menambahkan Pelanggan Baru
class PelangganAddPage extends StatefulWidget {
  @override
  _PelangganAddPageState createState() => _PelangganAddPageState();
}

class _PelangganAddPageState extends State<PelangganAddPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Fungsi untuk menambahkan pelanggan baru ke Supabase
  Future<void> addPelanggan() async {
    try {
      await Supabase.instance.client.from('Pelanggan').insert([
        {
          'NamaPelanggan': nameController.text,
          'Alamat': addressController.text,
          'NomorTelepon': phoneController.text,
        }
      ]);
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya dengan indikasi berhasil
    } catch (e) {
      print('Error adding pelanggan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pelanggan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama Pelanggan'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addPelanggan,
              child: Text('Simpan Pelanggan'),
            ),
          ],
        ),
      ),
    );
  }
}
