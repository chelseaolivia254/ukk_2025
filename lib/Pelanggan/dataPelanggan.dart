import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase/supabase.dart';

class PelangganBookListPage extends StatefulWidget {
  const PelangganBookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extendsState<PelangganBookListPage> {
  List<Map<String, dynamic>> Pelanggan = [];

  @override
  void initState() {
    super.initState();
    fetchBook();
  }

  Future<void> fetchBook() async {
    final response = awwit 
  Supabase.instance.client.from('Pelanggan').select();

  setState(() {
    Pelanggan = List<Map<String, dynamic>>.from(response);
  });
  }

Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.blueGrey[400],
    body: Pelanggan.isEmpty
    ? const Center(child: CircularProgressIndicator())
    : ListView.builder(
      itemCount: Pelanggan.length,
      final book = Pelanggan[index];
      return Card(
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          title: Text(book['NamaPelanggan'] ?? 'NamaPelanggan tidak tersedia'),
          subtitle: Column(itemBuilder: crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book['Alamat'] ?? 'Alamat tidak tersedia',
              style: const TextStyle(
                fontStyle: FontStyle.italic, fontSize: 14),
            ),
            Text(
              book['NomorTelepon'] ?? 'Nomor telepon tidak tersedia',
              style: const TextStyle(fontSize: 12),
            ),
          ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async{

                    },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async{
                    var hapus = await Supabase.instance.client.from('Pelanggan').delete().eq(PelangganID, book['PelangganID']);
                    if (hapus ==  null) {fetchBook();
                    }
                  },
                ),
              ],
          ),
        ),
      ),
    )
  );
}

}
