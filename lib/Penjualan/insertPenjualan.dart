import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Penjualan/dataPenjualan.dart';
import 'package:ukk_2025/homePage.dart';

class AddPenjualanPageState extends StatefulWidget {
  const AddPenjualanPageState({super.key});

  @override
  _AddPenjualanPageState createState() => _AddPenjualanPageState();
}

class _AddPenjualanPageState extends State<AddPenjualanPageState> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _TanggalPenjualanController = TextEditingController();
  final TextEditingController _TotalHargaController = TextEditingController();
  final TextEditingController _PelangganIDController = TextEditingController();

  Future<void> _addPenjualan() async {
    if (_formKey.currentState!.validate()) {
      final TanggalPenjualan = _TanggalPenjualanController.text;
      final TotalHarga = _TotalHargaController.text;
      final PelangganID = _PelangganIDController.text;

      try {
        final response = await Supabase.instance.client.from('Penjualan').insert({
          'TanggalPenjualan': TanggalPenjualan,
          'TotalHarga': TotalHarga,
          'PelangganID': PelangganID,
        });

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penjualan berhasil ditambahkan!')),
          );
          _TanggalPenjualanController.clear();
          _TotalHargaController.clear();
          _PelangganIDController.clear();
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
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
        title: const Text('Tambah Penjualan Baru'),
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
                  labelText: 'Total Harga',
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
                  labelText: 'Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pelanggan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addPenjualan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[200],
                ),
                child: const Text('Simpan', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
