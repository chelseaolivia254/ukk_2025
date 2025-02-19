import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Penjualan/dataPenjualan.dart';
import 'package:ukk_2025/homePage.dart';

class DetailPenjualanPage extends StatefulWidget {
  final int penjualanID;

  const DetailPenjualanPage({Key? key, required this.penjualanID}) : super(key: key);

  @override
  _DetailPenjualanPageState createState() => _DetailPenjualanPageState();
}

class _DetailPenjualanPageState extends State<DetailPenjualanPage> {
  Map<String, dynamic>? penjualan;
  List<Map<String, dynamic>> detailProduk = [];

  @override
  void initState() {
    super.initState();
    fetchDetailPenjualan();
  }

  Future<void> fetchDetailPenjualan() async {
    try {
      // Ambil data penjualan berdasarkan ID
      final response = await Supabase.instance.client
          .from('Penjualan')
          .select()
          .eq('PenjualanID', widget.penjualanID)
          .single();

      // Ambil detail produk terkait dengan penjualan ini
      final produkResponse = await Supabase.instance.client
          .from('DetailPenjualan')
          .select('PenjualanID, ProdukID, Jumlah, Subtotal, Produk(Nama, Harga)')
          .eq('PenjualanID', widget.penjualanID);

      setState(() {
        penjualan = response;
        detailProduk = List<Map<String, dynamic>>.from(produkResponse);
      });
    } catch (e) {
      print('Error fetching Detail Penjualan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Penjualan')),
      body: penjualan == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Penjualan ID: ${penjualan!['PenjualanID']}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Tanggal: ${penjualan!['TanggalPenjualan']}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Total Harga: Rp ${penjualan!['TotalHarga']}',
                      style: const TextStyle(fontSize: 16)),
                  const Divider(),
                  const Text('Produk yang Dibeli:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: detailProduk.length,
                      itemBuilder: (context, index) {
                        final item = detailProduk[index];
                        final produk = item['Produk'] ?? {};
                        return Card(
                          child: ListTile(
                            title: Text(produk['Nama'] ?? 'Nama Tidak Tersedia'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Produk ID: ${item['ProdukID']}'),
                                Text('Jumlah: ${item['Jumlah']}'),
                                Text('Harga Satuan: Rp ${produk['Harga']}'),
                                Text('Subtotal: Rp ${item['Subtotal']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
