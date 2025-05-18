import 'package:flutter/material.dart';
import 'package:wastetrack/view/main_tabview/maintab_nasabah_view.dart';
import 'package:wastetrack/view/page/histori_nasabah.dart';


class WasteDetailNasabahPage extends StatefulWidget {
  const WasteDetailNasabahPage({super.key});

  @override
  State<WasteDetailNasabahPage> createState() => _WasteDetailNasabahPageState();
}

class _WasteDetailNasabahPageState extends State<WasteDetailNasabahPage> {
  int selectedMonth = 3;
  int selectedYear = 2025;
  int _bottomNavIndex = 2;

  final List<String> months = [
    "Januari", "Februari", "Maret", "April", "Mei", "Juni",
    "Juli", "Agustus", "September", "Oktober", "November", "Desember"
  ];


  final List<Map<String, dynamic>> data = [
    {"name": "Kaleng", "value": 5},
    {"name": "Kaca", "value": 4},
    {"name": "Plastik PET", "value": 3},
    {"name": "Plastik PP", "value": 2},
    {"name": "Kertas Karton", "value": 1},
    {"name": "Styrofoam", "value": 1},
    {"name": "Logam", "value": 1},
    {"name": "Plastik PS", "value": 1},
    {"name": "Kardus", "value": 1},
    {"name": "Plastik HDPE", "value": 1},
    {"name": "Plastik PVC", "value": 1},
    {"name": "Plastik EPS", "value": 1},
    {"name": "Elektronik", "value": 1},
  ];

  void showMonthYearPicker() async {
    int tempMonth = selectedMonth;
    int tempYear = selectedYear;
    final years = [selectedYear - 1, selectedYear, selectedYear + 1];

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      // Bulan
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 36,
                          diameterRatio: 1.2,
                          perspective: 0.003,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(initialItem: tempMonth - 1),
                          onSelectedItemChanged: (idx) => tempMonth = idx + 1,
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, idx) {
                              final isSelected = (idx + 1) == tempMonth;
                              return Center(
                                child: Text(
                                  months[idx],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.black : Colors.grey,
                                  ),
                                ),
                              );
                            },
                            childCount: months.length,
                          ),
                        ),
                      ),
                      // Tahun
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 36,
                          diameterRatio: 1.2,
                          perspective: 0.003,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(initialItem: years.indexOf(tempYear)),
                          onSelectedItemChanged: (idx) => tempYear = years[idx],
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, idx) {
                              final isSelected = years[idx] == tempYear;
                              return Center(
                                child: Text(
                                  years[idx].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.black : Colors.grey,
                                  ),
                                ),
                              );
                            },
                            childCount: years.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedMonth = tempMonth;
                      selectedYear = tempYear;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainTabNasabahView()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HistoriNasabahPage()));
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = data.fold<int>(0, (sum, item) => sum + (item['value'] as int));
    final maxValue = data.isNotEmpty
        ? data.map((e) => e['value'] as int).reduce((a, b) => a > b ? a : b)
        : 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB7EACD), Color(0xFFF6F6F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 18, top: 24, right: 18),
              child: const Text(
                "Data Sampah",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF212529),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 120),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                  child: GestureDetector(
                    onTap: showMonthYearPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE8F5EC), width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.green,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${months[selectedMonth - 1]} $selectedYear",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(width: 7),
                          const Icon(Icons.calendar_today, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF96E3B8),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.recycling, color: Colors.black, size: 22),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Total Setoran Sampah",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "$total",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "Kg",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...data.asMap().entries.map((entry) {
                          int _ = entry.key;
                          var item = entry.value;
                          double percent = maxValue > 0 ? (item['value'] as int) / maxValue : 0.0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 96,
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FractionallySizedBox(
                                        widthFactor: percent,
                                        child: Container(
                                          height: 16,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Colors.black, Colors.grey.shade700],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Histori'),
          BottomNavigationBarItem(icon: Icon(Icons.delete_outline), label: 'Data Sampah'),
        ],
      ),
    );
  }
}
