import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/main.dart';

class AddProductPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    tambahProduct() async {
      var result = await Supabase.instance.client.from('produk').insert([
        {
          "NamaProduk": _nameController.text.trim(),
          "Harga": _priceController.text.trim(),
          "Stok": _stockController.text.trim()
        }
      ]);
      if (result == null) {
        Navigator.pop(context, true);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika untuk menyimpan produk
               tambahProduct();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

// Contoh penggunaan halaman tambah produk
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Utama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () {
              // Navigasi ke halaman tambah produk
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Halaman Utama'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}