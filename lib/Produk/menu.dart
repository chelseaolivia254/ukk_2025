import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Produk/tambahProduk.dart';
import 'package:ukk_2025/struk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eipxilvxaevdrtezggrw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpcHhpbHZ4YWV2ZHJ0ZXpnZ3J3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg4NTMsImV4cCI6MjA1NDk4NDg1M30.66T2kAZ_unpK10-el_Xe5ebCJxKRG2gft7OaRuQxRp8',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProdukBookListPageState(), // Perbaikan dari sebelumnya
    );
  }
}

class ProdukBookListPageState extends StatefulWidget {
  @override
  _ProdukBookListPageState createState() => _ProdukBookListPageState();
}

class _ProdukBookListPageState extends State<ProdukBookListPageState> {
  List<Map<String, dynamic>> foodMenu = [];
  List<Map<String, dynamic>> filteredMenu = [];
  List<Map<String, dynamic>> cart = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProduct();
    searchController.addListener(_filterProducts);
  }

  Future<void> fetchProduct() async {
    try {
      final response = await Supabase.instance.client.from('Produk').select();
      setState(() {
        foodMenu = List<Map<String, dynamic>>.from(response);
        filteredMenu = foodMenu;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMenu = foodMenu
          .where((item) => item['NamaProduk']
              .toString()
              .toLowerCase()
              .contains(query))
          .toList();
    });
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      int index = cart.indexWhere((cartItem) => cartItem['id'] == item['id']);
      if (index != -1) {
        cart[index]['quantity']++;
      } else {
        cart.add({...item, 'quantity': 1});
      }
    });
  }

  void _updateQuantity(int index, int quantity) {
    setState(() {
      if (quantity > 0) {
        cart[index]['quantity'] = quantity;
      } else {
        cart.removeAt(index);
      }
    });
  }

  double _calculateTotal() {
    return cart.fold(0, (sum, item) => sum + (item['Harga'] * item['quantity']));
  }

  void _showCart() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Keranjang Belanja'),
          content: cart.isEmpty
              ? Text('Keranjang kosong')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: cart.asMap().entries.map((entry) {
                    int index = entry.key;
                    var item = entry.value;
                    return ListTile(
                      title: Text(item['NamaProduk']),
                      subtitle: Text('Harga: ${item['Harga']} x ${item['quantity']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => _updateQuantity(index, item['quantity'] - 1),
                          ),
                          Text('${item['quantity']}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _updateQuantity(index, item['quantity'] + 1),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
          actions: [
            Text('Total: Rp${_calculateTotal()}'),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog sebelum pindah ke struk
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StrukPageState(cart: cart),// Pindah ke halaman struk
                  ),
                );
              },
              child: Text('Checkout'),
            ),
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
      appBar: AppBar(
        title: Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _showCart,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Cari Produk',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredMenu.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredMenu.length,
                    itemBuilder: (context, index) {
                      final item = filteredMenu[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          title: Text(item['NamaProduk'] ?? 'Nama Produk'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Harga: ${item['Harga'] ?? 'Tidak Tersedia'}'),
                              Text('Stok: ${item['Stok'] ?? 'Tidak Tersedia'}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.shopping_cart_checkout, color: Colors.green),
                            onPressed: () => _addToCart(item),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()), // Halaman tambah produk
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
