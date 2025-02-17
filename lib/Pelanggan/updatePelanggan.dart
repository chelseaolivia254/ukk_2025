import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UpdateBookPage extends StatefulWidget {
  final int id; // ID pelanggan untuk diupdate
  final String NamaPelanggan;
  final String Alamat;
  final String NomorTelepon;

  const UpdateBookPage({
    super.key,
    required this.id,
    required this.NamaPelanggan,
    required this.Alamat,
    required this.NomorTelepon,
  });

  @override
  _UpdateBookPageState createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _NamaPelangganController;
  late TextEditingController _AlamatController;
  late TextEditingController _NomorTeleponController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal
    _NamaPelangganController = TextEditingController(text: widget.NamaPelanggan);
    _AlamatController = TextEditingController(text: widget.Alamat);
    _NomorTeleponController = TextEditingController(text: widget.NomorTelepon);
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      final NamaPelanggan = _NamaPelangganController.text;
      final Alamat = _AlamatController.text;
      final NomorTelepon = _NomorTeleponController.text;

      try {
        // Kirim data update ke Supabase
        final response = await Supabase.instance.client
            .from('Pelanggan')
            .update({
              'NamaPelanggan': NamaPelanggan,
              'Alamat': Alamat,
              'NomorTelepon': NomorTelepon,
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
    _NamaPelangganController.dispose();
    _AlamatController.dispose();
    _NomorTeleponController.dispose();
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
                controller: _NamaPelangganController,
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
                controller: _AlamatController,
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
                controller: _NomorTeleponController,
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