import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wastetrack/view/page/data_sampah_nasabah.dart';
import 'package:wastetrack/view/page/histori_nasabah.dart';
import 'package:wastetrack/view/widget/Profile/profile.dart';
import 'package:wastetrack/view/widget/notifikasi.dart';
import 'package:wastetrack/global/userprofile.dart';


import '../page/bukti_permintaan.dart';


enum SortOption { semua, hargaTerendah, hargaTertinggi }

class MainTabNasabahView extends StatefulWidget {
  const MainTabNasabahView({super.key});

  @override
  State<MainTabNasabahView> createState() => _MainTabNasabahViewState();
}

class _MainTabNasabahViewState extends State<MainTabNasabahView> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  SortOption _sortOption = SortOption.semua;

  // picker bottom sheet
  final FixedExtentScrollController _dayController = FixedExtentScrollController(initialItem: 1);
  final FixedExtentScrollController _monthController = FixedExtentScrollController(initialItem: 1);
  final FixedExtentScrollController _yearController = FixedExtentScrollController(initialItem: 1);
  final FixedExtentScrollController _hourController = FixedExtentScrollController(initialItem: 1);
  final FixedExtentScrollController _minuteController = FixedExtentScrollController(initialItem: 1);
  final FixedExtentScrollController _zoneController = FixedExtentScrollController(initialItem: 0);

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
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // Home
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HistoriNasabahPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WasteDetailNasabahPage()),
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

  String _getNamaUtama() {
    if (userProfile == null) return '-';
    final role = userProfile!.role.toLowerCase();
    if (role.contains('mandiri')) {
      return userProfile!.name;
    } else if (role.contains('institusi') || role.contains('tps non-3r')) {
      return userProfile!.institusi;
    }
    return userProfile!.name; // fallback
  }

  void _goToNotification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotifikasiScreen(),
      ),
    );
  }

  void _showTarikSaldoSheet() {
    final now = DateTime(2025, 5, 16, 12, 39);
    final List<String> days = List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));
    final List<String> months = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    final List<String> hours = List.generate(24, (i) => i.toString().padLeft(2, '0'));
    final List<String> minutes = List.generate(60, (i) => i.toString().padLeft(2, '0'));
    final List<String> zones = ["WIB", "WITA", "WIT"];
    final List<String> years = List.generate(6, (i) => (2025 + i).toString());

    int selectedDay = now.day - 1;
    int selectedMonth = now.month - 1;
    int selectedYear = years.indexOf(now.year.toString());
    if (selectedYear == -1) selectedYear = 0; // fallback ke 2025 jika tahun tidak ada
    int selectedHour = now.hour;
    int selectedMinute = now.minute;
    int selectedZone = 2;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setState) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Tarik Saldo",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 70,
                                height: 80,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(initialItem: selectedYear),
                                  itemExtent: 36,
                                  diameterRatio: 1.2,
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      selectedYear = index;
                                    });
                                  },
                                  children: years
                                      .map((year) => Center(
                                    child: Text(
                                      year,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: selectedYear == years.indexOf(year)
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: selectedYear == years.indexOf(year)
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tanggal dan Waktu Pengambilan",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CupertinoPicker(
                                    scrollController: FixedExtentScrollController(initialItem: selectedDay),
                                    itemExtent: 36,
                                    diameterRatio: 1.2,
                                    onSelectedItemChanged: (i) => setState(() => selectedDay = i),
                                    children: days
                                        .map((d) => Center(
                                      child: Text(
                                        d,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CupertinoPicker(
                                    scrollController: FixedExtentScrollController(initialItem: selectedMonth),
                                    itemExtent: 36,
                                    diameterRatio: 1.2,
                                    onSelectedItemChanged: (i) => setState(() => selectedMonth = i),
                                    children: months
                                        .map((m) => Center(
                                      child: Text(
                                        m,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CupertinoPicker(
                                    scrollController: FixedExtentScrollController(initialItem: selectedHour),
                                    itemExtent: 36,
                                    diameterRatio: 1.2,
                                    onSelectedItemChanged: (i) => setState(() => selectedHour = i),
                                    children: hours
                                        .map((h) => Center(
                                      child: Text(
                                        h,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(":", style: TextStyle(fontSize: 22)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CupertinoPicker(
                                    scrollController: FixedExtentScrollController(initialItem: selectedMinute),
                                    itemExtent: 36,
                                    diameterRatio: 1.2,
                                    onSelectedItemChanged: (i) => setState(() => selectedMinute = i),
                                    children: minutes
                                        .map((m) => Center(
                                      child: Text(
                                        m,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CupertinoPicker(
                                    scrollController: FixedExtentScrollController(initialItem: selectedZone),
                                    itemExtent: 36,
                                    diameterRatio: 1.2,
                                    onSelectedItemChanged: (i) => setState(() => selectedZone = i),
                                    children: zones
                                        .map((z) => Center(
                                      child: Text(
                                        z,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 80),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Nominal Uang",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: const [
                              Icon(Icons.cancel_outlined, color: Colors.grey, size: 28),
                              Spacer(),
                              Text(
                                "Rp20,250",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BuktiPermintaanPage(data: {
                                    'name': 'Ahmad Putra',
                                    'id': 'USR2025-01',
                                    'amount': 'Rp20,250',
                                  },)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Kirim",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Halo, ${_getNamaUtama()}",
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
                        onPressed: _goToNotification,
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
                          "Saldo Tabungan",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userProfile?.role == "Nasabah Mandiri" ? "Rp1,000,000" : "-",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "Total Setor: 2 Kg",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Rincian Sampah →",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Icon(Icons.eco, size: 18, color: Colors.black),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Keanggotaan:",
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                    "Bank Sampah Mawar",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  userProfile?.id ?? "-",
                                  style: const TextStyle(fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.account_balance_wallet_outlined, size: 28),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Tarik Saldo",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: _showTarikSaldoSheet,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
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
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
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
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                style: TextStyle(fontSize: 12, color: Colors.grey),
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
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -1),
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
