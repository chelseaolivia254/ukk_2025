import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Produk/menu.dart';
import 'package:ukk_2025/homePage.dart';

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
  final TextEditingController passawordController = TextEditingController();
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

      _passwordError = passawordController.text.isEmpty
          ? 'Password tidak boleh kosong'
          : null;
    });

    if (_emailError == null && _passwordError == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
              controller: passawordController,
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
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationPage()));
              },
              child: Text('Belum punya akun? Registrasi'),
            )
          ],
        ),
      ),
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
  final TextEditingController confirmPasswordController =
      TextEditingController();
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
        _emailError == 'Format email tidak valid';
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
                    labelText: 'Konfirmasi Pasaword',
                    border: OutlineInputBorder(),
                    errorText: _confirmPasswordError,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Daftar'),
                ),
              ],
            )));
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
