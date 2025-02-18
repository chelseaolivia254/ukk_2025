import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/main.dart';
import 'package:ukk_2025/profilePage.dart';
import 'package:ukk_2025/Pelanggan/dataPelanggan.dart';
import 'package:ukk_2025/Penjualan/dataPenjualan.dart';
import 'package:ukk_2025/Produk/menu.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eipxilvxaevdrtezggrw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpcHhpbHZ4YWV2ZHJ0ZXpnZ3J3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg4NTMsImV4cCI6MjA1NDk4NDg1M30.66T2kAZ_unpK10-el_Xe5ebCJxKRG2gft7OaRuQxRp8',
  );

  runApp(MaterialApp(
    home: HomePageState(),
  ));
}

class HomePageState extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageState> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('HOME'),
          backgroundColor: Colors.blueGrey[500],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.inventory), text: 'Produk'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Penjualan'),
              Tab(icon: Icon(Icons.account_balance_wallet), text: 'Detail Penjualan'),
              
             
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
          ),
        ),

        
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey[600]),
                child: Text(
                  'Profil',
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
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.app_registration),
                title: Text('Registrasi'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            PelangganBookListPage(), //untuk menampilkan halaman Pelanggan
            ProdukBookListPageState(),
            PenjualanBookListPage(),
        
          ],
        ),
      ),
    );
  }
}

// ==========================
//  CLASS PELANGGAN
// ==========================
class PelangganPage extends StatefulWidget {
  @override
  _PelangganPageState createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  Future<List<Map<String, dynamic>>> fetchPelanggan() async {
    try {
      var response = await Supabase.instance.client.from('Pelanggan').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching pelanggan: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pelanggan')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPelanggan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada pelanggan tersedia.'));
          }

          var pelangganList = snapshot.data!;
          return ListView.builder(
            itemCount: pelangganList.length,
            itemBuilder: (context, index) {
              final item = pelangganList[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(item['Nama'] ?? 'Nama Tidak Tersedia'),
                  subtitle: Text('Email: ${item['Email'] ?? 'Email Tidak Tersedia'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ==========================
//  CLASS PRODUK
// ==========================
class ProdukBookListPage extends StatefulWidget {
  @override
  _ProdukBookListPageState createState() => _ProdukBookListPageState();
}

class _ProdukBookListPageState extends State<ProdukBookListPage> {
  Future<List<Map<String, dynamic>>> fetchProduct() async {
    try {
      var response = await Supabase.instance.client.from('Produk').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produk')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada produk tersedia.'));
          }

          var produkList = snapshot.data!;
          return ListView.builder(
            itemCount: produkList.length,
            itemBuilder: (context, index) {
              final item = produkList[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(item['NamaProduk'] ?? 'Produk Tidak Tersedia'),
                  subtitle: Text('Harga: Rp ${item['Harga'] ?? 'Harga Tidak Tersedia'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
        

// ==========================
//  CLASS PENJUALAN
// ==========================
class PenjualanPage extends StatefulWidget {
  @override
  _PenjualanPageState createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  Future<List<Map<String, dynamic>>> fetchPenjualan() async {
    try {
      var response = await Supabase.instance.client.from('Penjualan').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching Penjualan: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Penjualan')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPenjualan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada penjualan tersedia.'));
          }

          var penjualanList = snapshot.data!;
          return ListView.builder(
            itemCount: penjualanList.length,
            itemBuilder: (context, index) {
              final item = penjualanList[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(item['Tanggal'] ?? 'Tanggal Tidak Tersedia'),
                  subtitle: Text('Total: Rp ${item['Total'] ?? 'Total Tidak Tersedia'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// ==========================
//  CLASS REGISTRASI
// ==========================
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _register() {
    setState(() {
      String emailPattern =
          r"^[a-zA-Z0-9]+([._%+-]*[a-zA-Z0-9])*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$";
      RegExp regex = RegExp(emailPattern);

      _emailError =
          emailController.text.isEmpty ? 'Email tidak boleh kosong' : null;
      if (_emailError == null && !regex.hasMatch(emailController.text)) {
        _emailError = 'Format email tidak valid';
      }

      _passwordError = passwordController.text.isEmpty
          ? 'Password tidak boleh kosong'
          : null;
      _confirmPasswordError = confirmPasswordController.text.isEmpty
          ? 'Konfirmasi password tidak boleh kosong'
          : null;

      if (_passwordError == null && _confirmPasswordError == null) {
        if (passwordController.text != confirmPasswordController.text) {
          _confirmPasswordError = 'Password tidak cocok';
        }
      }
    });

    if (_emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                errorText: _emailError,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                errorText: _passwordError,
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                border: OutlineInputBorder(),
                errorText: _confirmPasswordError,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
