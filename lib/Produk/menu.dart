import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProdukBookListPageState extends StatefulWidget {
  @override
  _ProdukBookListPageState createState() => _ProdukBookListPageState();
}

class _ProdukBookListPageState extends State<ProdukBookListPageState> {
  List<Map<String, dynamic>> foodMenu = []; // Inisialisasi foodMenu sebagai list kosong
  final List<Map<String, dynamic>> cart = []; // Keranjang kosong

  @override
  void initState() {
    super.initState();
    fetchProduct(); // Memanggil fetchProduct() saat inisialisasi
  }

  // Fungsi untuk mengambil data Produk dari Supabase
  Future<void> fetchProduct() async {
    try {
      final response = await Supabase.instance.client.from('Produk').select();

      // Cek jika data tersedia
      if (response.isNotEmpty) {
        setState(() {
          foodMenu = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Fungsi untuk menambah item ke keranjang
  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item); // Menambahkan item ke keranjang
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} ditambahkan ke keranjang')),
    );
  }

  // Fungsi untuk menampilkan daftar produk dalam bentuk list
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Book List'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Tindakan membuka keranjang produk, bisa diarahkan ke halaman lain jika perlu
              _showCart();
            },
          ),
        ],
      ),
      body: foodMenu.isEmpty
          ? Center(child: CircularProgressIndicator()) // Tampilkan loading jika data belum diambil
          : ListView.builder(
              itemCount: foodMenu.length,
              itemBuilder: (context, index) {
                final item = foodMenu[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(item['name'] ?? 'Tanpa Nama'),
                    subtitle: Text('Harga: ${item['price'] ?? 'Tidak Tersedia'}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _addToCart(item), // Menambah item ke keranjang
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Fungsi untuk menampilkan keranjang
  void _showCart() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Keranjang Belanja'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: cart.map((item) {
              return ListTile(
                title: Text(item['name'] ?? 'Tanpa Nama'),
                subtitle: Text('Harga: ${item['price'] ?? 'Tidak Tersedia'}'),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
