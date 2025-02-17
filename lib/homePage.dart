import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/main.dart';
import 'package:ukk_2025/profilePage.dart';

void main() {
  runApp(MaterialApp(
    home: HomePageState(),
  ));
}

class HomePageState extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageState> {
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> foodMenu = [];
  List<Map<String, dynamic>> filteredMenu = [];
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchProduct();
    searchController.addListener(_filterMenu);
  }

  Future<void> fetchProduct() async {
    try {
      var response = await Supabase.instance.client.from('produk').select();
      if (response.isNotEmpty) {
        setState(() {
          foodMenu = List<Map<String, dynamic>>.from(response);
          filteredMenu = foodMenu; // Initialize filteredMenu
        });
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void _filterMenu() {
    setState(() {
      filteredMenu = foodMenu
          .where((item) => item['namaproduk']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
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
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Ensure LoginPage exists
    );
  }

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
              Tab(icon: Icon(Icons.account_balance_wallet),text: 'Detail Penjualan'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
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
          children: [
            PelangganBookListPageState(), // Untuk menampilkan Pelanggan page
            ProdukBookListPageState(),    // Untuk menampilkan Produk page
            AddPenjualanBookListPageState(), // Untuk menampilkan Penjualan page
            Center(child: Text('Detail Penjualan')), // Add actual content for 'Detail Penjualan'
          ],
        ),
      ),
    );
  }
}

class PelangganBookListPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Halaman Pelanggan'),
    );
  }
}

class ProdukBookListPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Produk Page'),
    );
  }
}

class AddPenjualanBookListPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Penjualan Page'),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =TextEditingController();
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
                padding: EdgeInsets.symmetric(
                    horizontal: 19, vertical: 15), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: Colors.blueGrey, // Set the background color of the bubble
                  borderRadius: BorderRadius.circular(
                      16), // Rounded corners for the bubble
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
