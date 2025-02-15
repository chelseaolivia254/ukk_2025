import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/main.dart';
import 'package:ukk_2025/homePage.dart';



class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>>? foodMenu;
  final List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  fetchProduct() async {
    final response = await Supabase.instance.client.from('produk');
    if (response.data != null && response.data.isNotEmpty) {
      setState(() {
        foodMenu = List<Map<String, dynamic>>.from(response.data);
      });
    }
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} ditambahkan ke keranjang')),
    );
  }

  void _showCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item['name']} ditambahkan ke keranjang')));
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Ubah ini sesuai jumlah tab yang Anda inginkan
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.food_bank)),
              Tab(icon: Icon(Icons.local_drink)),
              Tab(icon: Icon(Icons.local_pizza)),
              Tab(icon: Icon(Icons.fastfood)),
            ],
          ),
        ),
        body: foodMenu == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: foodMenu!.length,
                itemBuilder: (context, index) {
                  final item = foodMenu![index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Harga: ${item['price']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _addToCart(item),
                    ),
                  );
                },
              ),
      ),
    );
  }
}


