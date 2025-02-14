import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/main.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> foodMenu = [];

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    var response = await Supabase.instance.client.from('produk').select();
    if (response.isNotEmpty) {
      setState(() {
        foodMenu = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: cart.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(cart[index]['namaproduk']),
              subtitle: Text('Harga: Rp ${cart[index]['harga']}'),
            );
          },
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu Makanan dan Minuman'),
          backgroundColor: Colors.blueGrey[500],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.inventory), text: 'Produk'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Penjualan'),
              Tab(
                  icon: Icon(Icons.account_balance_wallet),
                  text: 'Detail Penjualan'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: _showCart,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey[600]),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profil'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
        body: foodMenu.isEmpty
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  Center(
                      child: Text(
                          'Pelanggan Page')), // Ganti dengan halaman pelanggan
                  MenuGrid(menu: foodMenu, addToCart: _addToCart),
                  Center(
                      child: Text(
                          'Penjualan Page')), // Ganti dengan halaman penjualan
                  Center(
                      child: Text(
                          'Detail Penjualan Page')), // Ganti dengan halaman detail penjualan
                ],
              ),
      ),
    );
  }
}

class MenuGrid extends StatelessWidget {
  final List<Map<String, dynamic>> menu;
  final Function(Map<String, dynamic>) addToCart;

  MenuGrid({required this.menu, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5,
      ),
      itemCount: menu.length,
      itemBuilder: (context, index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  menu[index]['namaproduk'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Harga: Rp ${menu[index]['harga']}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      color: Colors.blueGrey,
                      onPressed: () => addToCart(menu[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Center(child: Text('Halaman Profil')),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('Halaman Login')),
    );
  }
}
