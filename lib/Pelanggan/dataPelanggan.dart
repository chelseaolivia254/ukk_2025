import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PelangganBookListPage(),
    );
  }
}

class PelangganBookListPage extends StatefulWidget {
  @override
  _PelangganBookListPageState createState() => _PelangganBookListPageState();
}

class _PelangganBookListPageState extends State<PelangganBookListPage> {
  List<Map<String, dynamic>> pelanggan = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    try {
      final response =
          await Supabase.instance.client.from('Pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
    }
  }

  Future<void> deletePelanggan(int id) async {
    try {
      await Supabase.instance.client
          .from('Pelanggan')
          .delete()
          .match({'PelangganID': id});
      fetchPelanggan();
    } catch (e) {
      print('Error deleting pelanggan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: pelanggan.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pelanggan.length,
              itemBuilder: (context, index) {
                final customer = pelanggan[index];
                return Card(
                  color: Colors.blue[50],
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                        customer['NamaPelanggan'] ?? 'Nama tidak tersedia'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer['Alamat'] ?? 'Alamat tidak tersedia',
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                        Text(
                          customer['NomorTelepon'] ??
                              'Nomor telepon tidak tersedia',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PelangganAddPage(customer: customer),
                              ),
                            );
                            if (result == true) fetchPelanggan();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              deletePelanggan(customer['PelangganID']),
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
            MaterialPageRoute(builder: (context) => PelangganAddPage()),
          );
          if (result == true) fetchPelanggan();
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class PelangganAddPage extends StatefulWidget {
  final Map<String, dynamic>? customer;

  PelangganAddPage({this.customer});

  @override
  _PelangganAddPageState createState() => _PelangganAddPageState();
}

class _PelangganAddPageState extends State<PelangganAddPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      nameController.text = widget.customer!['NamaPelanggan'];
      addressController.text = widget.customer!['Alamat'];
      phoneController.text = widget.customer!['NomorTelepon'];
    }
  }

  Future<void> savePelanggan() async {
    try {
      if (widget.customer == null) {
        await Supabase.instance.client.from('Pelanggan').insert([
          {
            'NamaPelanggan': nameController.text,
            'Alamat': addressController.text,
            'NomorTelepon': phoneController.text,
          }
        ]);
      } else {
        await Supabase.instance.client.from('Pelanggan').update({
          'NamaPelanggan': nameController.text,
          'Alamat': addressController.text,
          'NomorTelepon': phoneController.text,
        }).match({'PelangganID': widget.customer!['PelangganID']});
      }
      Navigator.pop(context, true);
    } catch (e) {
      print('Error saving pelanggan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.customer == null ? 'Tambah Pelanggan' : 'Edit Pelanggan'),
        backgroundColor: const Color.fromARGB(255, 104, 187, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Nama Pelanggan
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Pelanggan',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(height: 16), // Jarak antar input

            // Input Alamat
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(height: 16),

            // Input Nomor Telepon
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24), // Jarak lebih besar sebelum tombol

            // Tombol Simpan
            ElevatedButton(
              onPressed: savePelanggan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Simpan',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
