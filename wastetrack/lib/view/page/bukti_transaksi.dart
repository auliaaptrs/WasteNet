import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wastetrack/view/main_tabview/main_tabview.dart';
import 'package:wastetrack/models/product.dart';

class BuktiTransaksiPage extends StatelessWidget {
  final String idNasabah;
  final List<Product> products;
  final int totalNominal;

  const BuktiTransaksiPage({
    super.key,
    required this.idNasabah,
    required this.products,
    required this.totalNominal,
  });

  String formatRupiah(num number) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
        .format(number);
  }

  void _goToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainTabView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6E2C2),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 350,
            margin: const EdgeInsets.symmetric(vertical: 40),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF6FCF97), size: 64),
                  const SizedBox(height: 12),
                  const Text(
                    'Penyetoran Sukses!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+${formatRupiah(totalNominal)}',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 18),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID $idNasabah', style: const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(
                          '${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())} WITA',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Detail Setoran', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      const TableRow(
                        children: [
                          Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Jumlah (Kg)', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Harga', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      ...products.map((p) => TableRow(
                        children: [
                          Text(p.nama, style: const TextStyle(color: Colors.black54)),
                          Text(p.jumlah.toString(), style: const TextStyle(color: Colors.black54)),
                          Text(formatRupiah(p.total), style: const TextStyle(color: Colors.black54)),
                        ],
                      )),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Setoran', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(formatRupiah(totalNominal), style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _goToDashboard(context),
                      icon: const Icon(Icons.close, color: Colors.black),
                      label: const Text('Tutup', style: TextStyle(color: Colors.black)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
