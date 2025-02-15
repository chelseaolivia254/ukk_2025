import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/main.dart';

class UpdateBookPage extends StatefulWidget {
  final int id; // ID pelanggan untuk diupdate
  final String namaPelanggan;
  final String alamat;
  final String nomorTelepon;

  const UpdateBookPage({
    super.key,
    required this.id,
    required this.namaPelanggan,
    required this.alamat,
    required this.nomorTelepon,
  });

  @override
  _UpdateBookPageState createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaPelangganController;
  late TextEditingController _alamatController;
  late TextEditingController _nomorTeleponController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal
    _namaPelangganController = TextEditingController(text: widget.namaPelanggan);
    _alamatController = TextEditingController(text: widget.alamat);
    _nomorTeleponController = TextEditingController(text: widget.nomorTelepon);
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      final namaPelanggan = _namaPelangganController.text;
      final alamat = _alamatController.text;
      final nomorTelepon = _nomorTeleponController.text;

      try {
        // Kirim data update ke Supabase
        final response = await Supabase.instance.client
            .from('pelanggan')
            .update({
              'namaPelanggan': namaPelanggan,
              'alamat': alamat,
              'nomorTelepon': nomorTelepon,
            })
            .eq('id', widget.id);

        if (response != null && response.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pelanggan berhasil diperbarui!')),
          );
          Navigator.pop(context, true); // Kembali ke halaman utama
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui pelanggan: ${response.error?.message}')),
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
    _namaPelangganController.dispose();
    _alamatController.dispose();
    _nomorTeleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbarui Pelanggan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaPelangganController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Pelanggan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomorTeleponController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Telepon tidak boleh kosong';
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
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}