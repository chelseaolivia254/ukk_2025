import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ci Coffee Shop'),
        backgroundColor: Colors.blueGrey[500],
        bottom: TabBar(
          controller: _tabController,
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
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PelangganPage(), // Halaman pelanggan ada di sini
          ProdukPage(),
          PenjualanPage(),
          Center(child: Text('Detail Penjualan')),
        ],
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








