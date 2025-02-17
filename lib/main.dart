import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Produk/tambahProduk.dart';
import 'package:ukk_2025/homePage.dart';
import 'package:ukk_2025/Produk/menu.dart';
import 'package:ukk_2025/Pelanggan/dataPelanggan.dart';
import 'package:ukk_2025/profilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eipxilvxaevdrtezggrw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpcHhpbHZ4YWV2ZHJ0ZXpnZ3J3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg4NTMsImV4cCI6MjA1NDk4NDg1M30.66T2kAZ_unpK10-el_Xe5ebCJxKRG2gft7OaRuQxRp8',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Halaman Kasir',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  void _login() {
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
    });

    if (_emailError == null && _passwordError == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Berhasil'),
          content: Text('Anda telah berhasil login!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageState()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 19, vertical: 15), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: Colors.blueGrey, // Set the background color of the bubble
                  borderRadius: BorderRadius.circular(
                      16), // Rounded corners for the bubble
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              child: Center(
                child: Image.asset(
                  'assets/images/Logo.jpg',
                  width: 200.0,
                  height: 200.0,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                errorText: _emailError,
                prefixIcon: Icon(Icons.person),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                errorText: _passwordError,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text('Selamat datang di Menu!'),
      ),
    );
  }
}
