import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Penjualan/dataPenjualan.dart';


class UpdatePenjualanBookPage extends StatefulWidget {
  final int id; // ID pelanggan untuk diupdate
  final String TanggalPenjualan;
  final String TotalHarga;
  final String PelangganID;

  const UpdatePenjualanBookPage({
    super.key,
    required this.id,
    required this.TanggalPenjualan,
    required this.TotalHarga,
    required this.PelangganID,
  });

  @override
  _UpdatePenjualanBookPageState createState() => _UpdatePenjualanBookPageState();
}

class _UpdatePenjualanBookPageState extends State<UpdatePenjualanBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _TanggalPenjualanController;
  late TextEditingController _TotalHargaController;
  late TextEditingController _PelangganIDController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal
    _TanggalPenjualanController = TextEditingController(text: widget.TanggalPenjualan);
    _TotalHargaController = TextEditingController(text: widget.TotalHarga);
    _PelangganIDController = TextEditingController(text: widget.PelangganID);
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      final TangganPenjualan = _TanggalPenjualanController.text;
      final TotalHarga = _TotalHargaController.text;
      final PelangganID = _PelangganIDController.text;

      try {
        // Kirim data update ke Supabase
        final response = await Supabase.instance.client
            .from('Penjualan')
            .update({
              'TanggalPenjualan': 'TanggalPenjualan',
              'TotalHarga': TotalHarga,
              'PelangganID': PelangganID,
            })
            .eq('id', widget.id);

        if (response != null && response.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penjualan berhasil diperbarui!')),
          );
          Navigator.pop(context, true); // Kembali ke halaman utama
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui penjualan: ${response.error?.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _TanggalPenjualanController.dispose();
    _TotalHargaController.dispose();
    _PelangganIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbarui Penjualan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _TanggalPenjualanController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Penjualan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Penjualan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _TotalHargaController,
                decoration: const InputDecoration(
                  labelText: 'TotalHarga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _PelangganIDController,
                decoration: const InputDecoration(
                  labelText: 'PelangganID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'PelangganID tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[200],
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}