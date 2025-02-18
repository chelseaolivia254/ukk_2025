import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Produk/tambahProduk.dart';

class ProdukBookListPageState extends StatefulWidget {
  @override
  _ProdukBookListPageState createState() => _ProdukBookListPageState();
}

class _ProdukBookListPageState extends State<ProdukBookListPageState> {
  List<Map<String, dynamic>> foodMenu = []; // Daftar produk
  final List<Map<String, dynamic>> cart = []; // Keranjang belanja

  @override
  void initState() {
    super.initState();
    fetchProduct(); // Ambil data produk saat pertama kali membuka halaman
  }

  // Fungsi mengambil data Produk dari Supabase
  Future<void> fetchProduct() async {
    try {
      final response = await Supabase.instance.client.from('Produk').select();
      if (response.isNotEmpty) {
        setState(() {
          foodMenu = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Fungsi menambah produk ke keranjang
  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} ditambahkan ke keranjang')),
    );
  }

  // Fungsi menghapus produk dari database
  Future<void> _deleteProduct(int productId) async {
    try {
      await Supabase.instance.client.from('Produk').delete().match({'id': productId});
      setState(() {
        foodMenu.removeWhere((item) => item['id'] == productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  // Fungsi untuk menampilkan dialog Edit Produk
  void _editProduct(Map<String, dynamic> item) {
    TextEditingController nameController = TextEditingController(text: item['name']);
    TextEditingController priceController = TextEditingController(text: item['price'].toString());
    TextEditingController stockController = TextEditingController(text: item['stock'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Produk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.from('Produk').update({
                    'name': nameController.text,
                    'price': int.parse(priceController.text),
                    'stock': int.parse(stockController.text),
                  }).match({'id': item['id']});

                  fetchProduct(); // Refresh data
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Produk berhasil diperbarui')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal memperbarui produk: $e')),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
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
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: foodMenu.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: foodMenu.length,
              itemBuilder: (context, index) {
                final item = foodMenu[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(item['name'] ?? 'Tanpa Nama'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga: ${item['price'] ?? 'Tidak Tersedia'}'),
                        Text('Stok: ${item['stock'] ?? 'Tidak Tersedia'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editProduct(item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(item['id']),
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
            MaterialPageRoute(builder: (context) =>  AddProductPage()),
          );
          if (result == true) {
            fetchProduct();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
