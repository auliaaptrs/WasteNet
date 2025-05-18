
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wastetrack/view/main_tabview/main_tabview.dart';
import 'package:wastetrack/view/page/bukti_transaksi.dart';

import 'package:wastetrack/models/product.dart';


import 'package:wastetrack/view/page/histori.dart';
import 'package:wastetrack/view/page/data_sampah.dart';

final List<Map<String, dynamic>> jenisSampah = [
  {
    "jenis": "Kaleng",
    "produk": [
      {"nama": "Coca Cola", "harga": 3000},
      {"nama": "Fanta", "harga": 2500},
    ]
  },
  {
    "jenis": "Botol PET",
    "produk": [
      {"nama": "Aqua", "harga": 2000},
      {"nama": "Le Minerale", "harga": 1800},
    ]
  },
];

class SetorSampahPage extends StatefulWidget {
  const SetorSampahPage({super.key});

  @override
  State<SetorSampahPage> createState() => _SetorSampahPageState();
}

class _SetorSampahPageState extends State<SetorSampahPage> {
  final TextEditingController idController = TextEditingController();

  bool hasImage = false;

  List<Product> products = [];

  int _bottomNavIndex = 2; // 0=Beranda,1=Histori,2=Transaksi(Setor),3=Data Sampah

  String formatRupiah(num number) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
        .format(number);
  }

  int get totalNominal => products.fold(0, (sum, p) => sum + p.total);

  void addProduct() {
    setState(() {
      products.add(Product(
        jenis: jenisSampah[0]['jenis'],
        nama: jenisSampah[0]['produk'][0]['nama'],
        harga: jenisSampah[0]['produk'][0]['harga'],
        jumlah: 0.0,
        satuan: 'Kg',
      ));
    });
  }

  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void clearProducts() {
    setState(() {
      products.clear();
    });
  }

  void updateProduct(int index, Product newProduct) {
    setState(() {
      products[index] = newProduct;
    });
  }

  void _onBottomNavTapped(int index) {
    if (_bottomNavIndex == index) return;
    setState(() => _bottomNavIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainTabView()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HistoriPage()));
    } else if (index == 2) {
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => WasteDetailPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB7EACD), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 18, top: 24, right: 18),
              child: const Text(
                "Transaksi Sampah",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF212529),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          const Text(
                            "ID Nasabah",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212529)),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: idController,
                            decoration: InputDecoration(
                              hintText: "ID-123-456-789-00",
                              hintStyle:
                              const TextStyle(color: Color(0xFFBDBDBD)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                const BorderSide(color: Color(0xFF6FCF97)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFF6FCF97), width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            "Tambahkan Bukti Transaksi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212529),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      hasImage = true;
                                    });
                                  },
                                  child: Container(
                                    height: 62,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xFF6FCF97)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: hasImage
                                          ? const Icon(Icons.image,
                                          size: 38,
                                          color: Color(0xFF6FCF97))
                                          : const Icon(Icons.add,
                                          size: 38,
                                          color: Color(0xFFBDBDBD)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 32,
                                    child: ElevatedButton(
                                      onPressed: hasImage
                                          ? () {
                                        setState(() {
                                          hasImage = false;
                                        });
                                      }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        foregroundColor: Colors.black54,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                      ),
                                      child: const Text("Hapus Gambar"),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 150,
                                    height: 32,
                                    child: ElevatedButton(
                                      onPressed: hasImage ? () {} : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        const Color(0xFF212529),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                      ),
                                      child: const Text("Edit Gambar"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Detail Sampah",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF212529))),
                              GestureDetector(
                                onTap: products.isNotEmpty ? clearProducts : null,
                                child: Text(
                                  "Hapus Semua",
                                  style: TextStyle(
                                    color: products.isNotEmpty
                                        ? Colors.grey
                                        : Colors.grey[300],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // List produk
                          ...products.asMap().entries.map((entry) {
                            int idx = entry.key;
                            Product product = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FB),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: product.jenis,
                                          items: jenisSampah
                                              .map((e) => DropdownMenuItem<String>(
                                            value: e['jenis'],
                                            child: Text(
                                              e['jenis'],
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 15),
                                            ),
                                          ))
                                              .toList(),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF2F2F2),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 0),
                                          ),
                                          onChanged: (value) {
                                            final found = jenisSampah.firstWhere(
                                                    (e) => e['jenis'] == value);
                                            final produkPertama = found['produk'][0];
                                            updateProduct(
                                              idx,
                                              Product(
                                                jenis: found['jenis'],
                                                nama: produkPertama['nama'],
                                                harga: produkPertama['harga'],
                                                jumlah: product.jumlah,
                                                satuan: product.satuan,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.grey),
                                        onPressed: () => removeProduct(idx),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: product.nama,
                                          items: jenisSampah
                                              .firstWhere(
                                                  (e) => e['jenis'] == product.jenis)[
                                          'produk']
                                              .map<DropdownMenuItem<String>>(
                                                  (p) => DropdownMenuItem<String>(
                                                value: p['nama'],
                                                child: Text(
                                                  p['nama'],
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ))
                                              .toList(),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF2F2F2),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 0),
                                          ),
                                          onChanged: (value) {
                                            final found = jenisSampah
                                                .firstWhere(
                                                    (e) => e['jenis'] == product.jenis)[
                                            'produk']
                                                .firstWhere((p) => p['nama'] == value);
                                            updateProduct(
                                              idx,
                                              Product(
                                                jenis: product.jenis,
                                                nama: found['nama'],
                                                harga: found['harga'],
                                                jumlah: product.jumlah,
                                                satuan: product.satuan,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Jumlah
                                      SizedBox(
                                        width: 70,
                                        child: TextFormField(
                                          initialValue: product.jumlah.toString(),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF2F2F2),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 0),
                                          ),
                                          onChanged: (val) {
                                            double jumlah = double.tryParse(val) ?? 0.0;
                                            updateProduct(
                                              idx,
                                              Product(
                                                jenis: product.jenis,
                                                nama: product.nama,
                                                harga: product.harga,
                                                jumlah: jumlah,
                                                satuan: product.satuan,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Satuan
                                      SizedBox(
                                        width: 50,
                                        child: TextFormField(
                                          initialValue: product.satuan,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF2F2F2),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 0),
                                          ),
                                          onChanged: (val) {
                                            updateProduct(
                                              idx,
                                              Product(
                                                jenis: product.jenis,
                                                nama: product.nama,
                                                harga: product.harga,
                                                jumlah: product.jumlah,
                                                satuan: val,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Harga
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Harga: ${formatRupiah(product.harga)}",
                                        style: const TextStyle(
                                            color: Color(0xFF6FCF97),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Total: ${formatRupiah(product.total)}",
                                        style: const TextStyle(
                                            color: Color(0xFF212529),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: addProduct,
                              icon: const Icon(Icons.add,
                                  color: Color(0xFF6FCF97)),
                              label: const Text(
                                "Tambah Sampah",
                                style: TextStyle(color: Color(0xFF6FCF97)),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF2F2F2),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Total nominal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF212529)),
                              ),
                              Text(
                                formatRupiah(totalNominal),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF212529),
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              onPressed: products.isNotEmpty &&
                                  idController.text.isNotEmpty
                                  ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BuktiTransaksiPage(
                                          idNasabah: idController.text,
                                          products: products,
                                          totalNominal: totalNominal,
                                        ),
                                  ),
                                );
                              }
                                  : null,
                              style: TextButton.styleFrom(
                                backgroundColor: products.isNotEmpty &&
                                    idController.text.isNotEmpty
                                    ? const Color(0xFF6FCF97)
                                    : Colors.grey[300],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Simpan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: _onBottomNavTapped,
        iconSize: 32,
        selectedIconTheme: const IconThemeData(size: 40),
        unselectedIconTheme: const IconThemeData(size: 30),
        selectedItemColor: const Color(0xFF6FCF97),
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Histori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline),
            label: 'Data Sampah',
          ),
        ],
      ),
    );
  }
}
