import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StrukPageState extends StatelessWidget {
  final List<Map<String, dynamic>> cart;

  StrukPageState({required this.cart});

  double _calculateTotal() {
    return cart.fold(0, (sum, item) => sum + (item['Harga'] * item['quantity']));
  }

  Future<void> _printInvoice(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Struk Pembelian", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                context: context,
                headers: ['Nama Produk', 'Harga', 'Qty', 'Total'],
                data: cart.map((item) => [
                  item['NamaProduk'],
                  'Rp${item['Harga']}',
                  '${item['quantity']}',
                  'Rp${item['Harga'] * item['quantity']}'
                ]).toList(),
              ),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Total: Rp${_calculateTotal()}',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Struk Pembelian')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  title: Text(item['NamaProduk']),
                  subtitle: Text('Rp${item['Harga']} x ${item['quantity']}'),
                  trailing: Text('Rp${item['Harga'] * item['quantity']}'),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total: Rp${_calculateTotal()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => _printInvoice(context),
            child: Text('Cetak Struk'),
          ),
        ],
      ),
    );
  }
}
