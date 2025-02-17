import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Pelanggan/dataPelanggan.dart';

class AddPenjualanBookListPageState extends StatefulWidget {
  final int? penjualanid;

  AddPenjualanBookListPageState({Key? key, this.penjualanid}) : super(key: key);

  @override
  _PenjualanBookListPageState createState() => _PenjualanBookListPageState();
}

class _PenjualanBookListPageState extends State<AddPenjualanBookListPageState> {
  final TextEditingController TanggalPenjualan = TextEditingController();
  final TextEditingController TotalHarga = TextEditingController();
  final TextEditingController PelangganID = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> penjualan = [];

  @override
  void initState() {
    super.initState();
    if (widget.penjualanid != null) {
      fetchPenjualanById(widget.penjualanid!); // Jika ada penjualanid, ambil data khusus
    } else {
      fetchPenjualan();
    }
  }

  // Ambil data penjualan berdasarkan ID penjualan
  Future<void> fetchPenjualanById(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('Penjualan')
          .select()
          .eq('penjualanid', id)
          .single();
      setState(() {
        TanggalPenjualan.text = response['TanggalPenjualan'];
        TotalHarga.text = response['TotalHarga'].toString();
        PelangganID.text = response['PelangganID'].toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Ambil semua data penjualan
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

  // Hapus data penjualan berdasarkan ID
  Future<void> deletePenjualan(int id) async {
    try {
      await Supabase.instance.client.from('Penjualan').delete().eq('penjualanid', id);
      fetchPenjualan(); // Refresh after deletion
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting: $e')));
    }
  }

  // Fungsi untuk menyimpan atau memperbarui penjualan
 // Fungsi untuk menyimpan atau memperbarui penjualan
Future<void> savePenjualan() async {
  if (formKey.currentState!.validate()) {
    try {
      final data = {
        'TanggalPenjualan': TanggalPenjualan.text,
        'TotalHarga': double.tryParse(TotalHarga.text),
        'PelangganID': int.tryParse(PelangganID.text),
      };

      if (widget.penjualanid != null && widget.penjualanid is int) {
        // Jika widget.penjualanid ada (tidak null), maka lakukan update
        final response = await Supabase.instance.client
            .from('Penjualan')
            .update(data)  // Data yang ingin diupdate
            .eq('penjualanid', widget.penjualanid is int);  // Pastikan penjualanid ada

        // Menangani error jika ada
        if (response.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error updating: ${response.error!.message}')));
        }
      } else {
        // Jika widget.penjualanid tidak ada (null), maka lakukan insert
        await Supabase.instance.client.from('Penjualan').insert([data]);
      }

      Navigator.pop(context, true); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving penjualan: $e')));
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Tambah / Edit Penjualan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: TanggalPenjualan,
              decoration: InputDecoration(labelText: 'Tanggal Penjualan'),
              validator: (value) => value!.isEmpty ? 'Tanggal tidak boleh kosong' : null,
            ),
            TextFormField(
              controller: TotalHarga,
              decoration: InputDecoration(labelText: 'Total Harga'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Total harga tidak boleh kosong' : null,
            ),
            TextFormField(
              controller: PelangganID,
              decoration: InputDecoration(labelText: 'Pelanggan ID'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Pelanggan ID tidak boleh kosong' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePenjualan,
              child: Text(widget.penjualanid != null ? 'Update Penjualan' : 'Tambah Penjualan'),
            ),
            SizedBox(height: 20),
            penjualan.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
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
                              Text('Total Harga: ${book['TotalHarga']}' ?? 'Total Harga Tidak Tersedia'),
                              Text('Pelanggan ID: ${book['PelangganID']}' ?? 'Pelanggan Tidak Tersedia'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Edit logika jika dibutuhkan
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deletePenjualan(book['penjualanid']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
