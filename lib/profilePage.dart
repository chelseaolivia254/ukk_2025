import 'package:flutter/material.dart';
import 'package:ukk_2025/main.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Petugas'),
            subtitle: Text('Informasi tentang petugas'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Admin'),
            subtitle: Text('Informasi tentang admin'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ci Coffee Shop'),
          backgroundColor: Colors.blueGrey[500],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.inventory), text: 'Produk'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Penjualan'),
              Tab(icon: Icon(Icons.account_balance_wallet), text: 'Detail Penjualan'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey[600]),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
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
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PelangganPage(),
            ProdukPage(),
            PenjualanPage(),
            Center(child: Text('Detail Penjualan')),
          ],
        ),
      ),
    );
  }
}

class PelangganPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman Pelanggan'));
  }
}

class ProdukPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman Produk'));
  }
}

class PenjualanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Halaman Penjualan'));
  }
}
