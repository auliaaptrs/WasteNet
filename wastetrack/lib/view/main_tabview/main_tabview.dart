import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wastetrack/view/page/daftar_anggota.dart';
import 'package:wastetrack/view/page/histori.dart';
import 'package:wastetrack/view/page/list_kirim_saldo.dart';
import 'package:wastetrack/view/page/setor.dart';
import 'package:wastetrack/view/page/ubah_harga.dart';
import 'package:wastetrack/view/page/data_sampah.dart';
import 'package:wastetrack/view/widget/Profile/profile.dart';
import 'package:wastetrack/global/banksampahprofile.dart';

enum SortOption { semua, hargaTerendah, hargaTertinggi }

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  final int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  SortOption _sortOption = SortOption.semua;

  final List<Map<String, dynamic>> items = [
    {
      "name": "Coca Cola 200 ml",
      "img": "assets/img/coke.png",
      "price": 5000,
    },
    {
      "name": "Aqua 1.5 liter",
      "img": "assets/img/Aqua.png",
      "price": 3000,
    },
    {
      "name": "Vit 550 ml",
      "img": "assets/img/vit.png",
      "price": 4000,
    },
    {
      "name": "Indomie goreng",
      "img": "assets/img/indomie.png",
      "price": 3000,
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    List<Map<String, dynamic>> filtered = items
        .where((item) => item["name"]
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()))
        .toList();

    if (_sortOption == SortOption.hargaTerendah) {
      filtered.sort((a, b) => a["price"].compareTo(b["price"]));
    } else if (_sortOption == SortOption.hargaTertinggi) {
      filtered.sort((a, b) => b["price"].compareTo(a["price"]));
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTabView()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoriPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SetorSampahPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WasteDetailPage()),
        );
        break;
    }
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                       "Halo, ${bankSampahProfile?.namaBank ?? ''}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.person_outline),
                        onPressed: _goToProfile,
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: _goToProfile,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage("assets/img/bg_card.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Saldo Rekening",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Rp1,200,000",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Tabungan Nasabah (80%)",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          "Rp960,000",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Saldo Bersih (20%)",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          "Rp240,000",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "Sisa Kapasitas:",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "50 Kg",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.eco, size: 20, color: Colors.black),
                                  const SizedBox(width: 8),
                                  Container(
                                    constraints: const BoxConstraints(maxWidth: 100),
                                    child: Text(
                                      bankSampahProfile?.bankId ?? '',
                                      style: const TextStyle(fontSize: 13, color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 20),

                // ACTION BUTTONS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.group, size: 28),
                          label: const Text(
                            "Daftar\nAnggota",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DaftarAnggotaPage()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF4CAF50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 8,
                            ),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.local_offer, size: 28),
                          label: const Text(
                            "Ubah\nHarga",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UbahHargaPage()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF4CAF50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.attach_money, size: 28),
                          label: const Text(
                            "Kirim\nSaldo",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ListKirimSaldoPage()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF4CAF50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Harga Sampah di Induk",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortOption = SortOption.semua;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              "Semua",
                              style: TextStyle(
                                color: _sortOption == SortOption.semua
                                    ? Colors.green
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_sortOption == SortOption.semua)
                              Container(
                                height: 2,
                                width: 30,
                                color: Colors.green,
                                margin: const EdgeInsets.only(top: 2),
                              )
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<SortOption>(
                        value: _sortOption == SortOption.semua ? null : _sortOption,
                        hint: Text(
                          "Harga",
                          style: TextStyle(
                            color: _sortOption == SortOption.semua
                                ? Colors.grey
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: SortOption.hargaTerendah,
                            child: Text("Harga Terendah"),
                          ),
                          DropdownMenuItem(
                            value: SortOption.hargaTertinggi,
                            child: Text("Harga Tertinggi"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sortOption = value;
                            });
                          }
                        },
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                      ),
                      const SizedBox(width: 0),
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              hintText: "Cari Sampah",
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 210,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Container(
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 12),
                              Image.asset(
                                item["img"],
                                fit: BoxFit.contain,
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 30),
                              Text(
                                "Rp${item["price"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  item["name"],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const Text(
                                "1 kg",
                                style:
                                TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onNavBarTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.green.shade700,
              unselectedItemColor: Colors.black54,
              iconSize: 32,
              selectedIconTheme: const IconThemeData(size: 40),
              unselectedIconTheme: const IconThemeData(size: 30),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Beranda",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: "Histori",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping),
                  label: "Transaksi",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.delete_outline),
                  label: "Data Sampah",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
