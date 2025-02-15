import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Pelanggan/dataPelanggan.dart';

class AddPenjualanBookListPage extends StatefulWidget {
  final int? penjualanid;
  
  AddPenjualanBookListPage({Key? key, this.penjualanid}) : super(key: key);

  @override
  _PenjualanBookListPageState createState() => _PenjualanBookListPageState();
}

class _PenjualanBookListPageState extends State<AddPenjualanBookListPage> {
  final TextEditingController TanggalPenjualan = TextEditingController();
  final TextEditingController TotalHarga = TextEditingController();
  final TextEditingController PelangganID = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> penjualan = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    try {
      final response = await Supabase.instance.client.from('Penjualan').select();
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> deletePenjualan(int id) async {
    try {
      await Supabase.instance.client.from('Penjualan').delete().eq('penjualanid', id);
      fetchPenjualan(); // Refresh after deletion
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: penjualan.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: penjualan.length,
              itemBuilder: (context, index) {
                final book = penjualan[index];
                return Card(
                  color: Colors.blue[50],
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(book['TanggalPenjualan'] ?? 'Tanggal tidak tersedia'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Harga: ${book['TotalHarga']}' ?? 'Total Harga Tidak Tersedia',
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                        Text(
                          'Pelanggan ID: ${book['PelangganID']}' ?? 'Pelanggan Tidak Tersedia',
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
                          onPressed: () => deletePenjualan(book['penjualanid']),
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
            MaterialPageRoute(builder: (context) => PelangganBookListPage()), // Ensure this page exists
          );
          if (result == true) {
            fetchPenjualan(); // Refresh data
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
