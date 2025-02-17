import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPelangganPageState extends StatefulWidget {
  const AddPelangganPageState({super.key});

  @override
  _AddPelangganPageState createState() => _AddPelangganPageState();
}

class _AddPelangganPageState extends State<AddPelangganPageState> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _NamaPelangganController = TextEditingController();
  final TextEditingController _AlamatController = TextEditingController();
  final TextEditingController _NomorTeleponController = TextEditingController();

  Future<void> _addPelanggan() async {
    if (_formKey.currentState!.validate()) {
      final NamaPelanggan = _NamaPelangganController.text;
      final Alamat = _AlamatController.text;
      final NomorTelepon = _NomorTeleponController.text;

      try {
        final response = await Supabase.instance.client.from('Pelanggan').insert({
          'NamaPelanggan': NamaPelanggan,
          'Alamat': Alamat,
          'NomorTelepon': NomorTelepon,
        });

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pelanggan berhasil ditambahkan!')),
          );

          _NamaPelangganController.clear();
          _AlamatController.clear();
          _NomorTeleponController.clear();

          Navigator.pop(context, true); // Kembali ke halaman utama dengan hasil sukses
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan pelanggan: $e')),
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
        title: const Text('Tambah Pelanggan Baru'),
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
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Telepon tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Nomor Telepon harus angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addPelanggan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[200],
                ),
                child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 19, vertical: 15), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: Colors.blueGrey, // Set the background color of the bubble
                  borderRadius: BorderRadius.circular(
                      16), // Rounded corners for the bubble
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
