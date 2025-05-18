import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wastetrack/view/main_tabview/main_tabview.dart';
import 'package:wastetrack/view/page/setor.dart';
import 'package:wastetrack/view/page/data_sampah.dart';

class Transaction {
  final String id;
  final String name;
  final String details;
  final int amount;
  final DateTime dateTime;
  final String type;

  Transaction({
    required this.id,
    required this.name,
    required this.details,
    required this.amount,
    required this.dateTime,
    required this.type,
  });
}

class HistoriPage extends StatefulWidget {
  const HistoriPage({super.key});

  @override
  State<HistoriPage> createState() => _HistoriPageState();
}

class _HistoriPageState extends State<HistoriPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "semua";

  late int _selectedMonth;
  late int _selectedYear;

  final List<Transaction> _allTransactions = [
    Transaction(
      id: "NSBI-25050001",
      name: "Penyetoran Sampah",
      details: "Rincian Transaksi",
      amount: 3000,
      dateTime: DateTime(2025, 5, 2, 12, 0),
      type: "pemasukan",
    ),
    Transaction(
      id: "NSBM-25050002",
      name: "Pengiriman Tunai",
      details: "Rincian Transaksi",
      amount: -3000,
      dateTime: DateTime(2025, 5, 3, 10, 0),
      type: "pengeluaran",
    ),
    Transaction(
      id: "NSBI-25050003",
      name: "Hasil Penjualan",
      details: "2 Kg",
      amount: 3000,
      dateTime: DateTime(2025, 5, 5, 14, 0),
      type: "pemasukan",
    ),
    Transaction(
      id: "NSBM-25050004",
      name: "Tarik Dana Pribadi",
      details: "Gaji Karyawan",
      amount: -3000,
      dateTime: DateTime(2025, 5, 7, 9, 0),
      type: "pengeluaran",
    ),
    Transaction(
      id: "NSBI-25050005",
      name: "Pemasukan Lainnya",
      details: "Dana Hibah",
      amount: 3000,
      dateTime: DateTime(2025, 5, 10, 12, 0),
      type: "pemasukan",
    ),
    Transaction(
      id: "NSBM-25050006",
      name: "Pemasukan Lainnya",
      details: "Dana Hibah",
      amount: 3000,
      dateTime: DateTime(2025, 5, 12, 11, 0),
      type: "pemasukan",
    ),
    Transaction(
      id: "NSBI-25050007",
      name: "Penyetoran Sampah",
      details: "Rincian Transaksi",
      amount: 3000,
      dateTime: DateTime(2025, 5, 14, 10, 0),
      type: "pemasukan",
    ),
    Transaction(
      id: "NSBM-25050008",
      name: "Pengiriman Tunai",
      details: "Rincian Transaksi",
      amount: -3000,
      dateTime: DateTime(2025, 5, 15, 15, 0),
      type: "pengeluaran",
    ),
    Transaction(
      id: "NSBI-25050009",
      name: "Hasil Penjualan",
      details: "2 Kg",
      amount: 3000,
      dateTime: DateTime(2025, 5, 17, 14, 0),
      type: "pemasukan",
    ),
    Transaction(
      id: "NSBM-25050010",
      name: "Tarik Dana Pribadi",
      details: "Gaji Karyawan",
      amount: -3000,
      dateTime: DateTime(2025, 5, 18, 9, 0),
      type: "pengeluaran",
    ),
    Transaction(
      id: "NSBI-25050011",
      name: "Pemasukan Lainnya",
      details: "Dana Hibah",
      amount: 3000,
      dateTime: DateTime(2025, 5, 20, 12, 0),
      type: "pemasukan",
    ),
    Transaction(
      id: "NSBM-25050012",
      name: "Pemasukan Lainnya",
      details: "Dana Hibah",
      amount: 3000,
      dateTime: DateTime(2025, 5, 22, 13, 0),
      type: "pemasukan",
    ),
  ];


  int _bottomNavIndex = 1;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  List<Transaction> get filteredTransactions {
    final searchText = _searchController.text.toLowerCase();
    return _allTransactions.where((transaction) {
      final matchesSearch =
          searchText.isEmpty || transaction.id.toLowerCase().contains(searchText);
      final matchesFilter =
          _selectedFilter == "semua" || transaction.type == _selectedFilter;
      final matchesMonthYear =
          transaction.dateTime.month == _selectedMonth &&
              transaction.dateTime.year == _selectedYear;
      return matchesSearch && matchesFilter && matchesMonthYear;
    }).toList();
  }

  Future<void> _showMonthYearPicker() async {
    int tempMonth = _selectedMonth;
    int tempYear = _selectedYear;
    final months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - 2 + i);

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Picker Bulan
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          diameterRatio: 1.2,
                          perspective: 0.003,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(initialItem: tempMonth - 1),
                          onSelectedItemChanged: (idx) {
                            tempMonth = idx + 1;
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, idx) {
                              final isSelected = (idx + 1) == tempMonth;
                              return Center(
                                child: Text(
                                  months[idx],
                                  style: TextStyle(
                                    fontSize: 20,
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
                      // Picker Tahun
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          diameterRatio: 1.2,
                          perspective: 0.003,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(initialItem: years.indexOf(tempYear)),
                          onSelectedItemChanged: (idx) {
                            tempYear = years[idx];
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, idx) {
                              final isSelected = years[idx] == tempYear;
                              return Center(
                                child: Text(
                                  years[idx].toString(),
                                  style: TextStyle(
                                    fontSize: 20,
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
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedMonth = tempMonth;
                      _selectedYear = tempYear;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Filter"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text("Semua"),
              value: "semua",
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Pemasukan"),
              value: "pemasukan",
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Pengeluaran"),
              value: "pengeluaran",
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == _bottomNavIndex) return;
    setState(() {
      _bottomNavIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainTabView()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SetorSampahPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WasteDetailPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB7EACD), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Histori",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: _showMonthYearPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.green.shade100, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${months[_selectedMonth - 1]} $_selectedYear",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.calendar_today, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: "Cari ID",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: _showFilterDialog,
                          tooltip: 'Filter transaksi',
                        ),
                      ),
                    ],
                  ),

                  // List transaksi
                  Expanded(
                    child: filteredTransactions.isEmpty
                        ? const Center(
                      child: Text(
                        "Tidak ada transaksi.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                        : ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, idx) {
                        final trx = filteredTransactions[idx];
                        final isIncome = trx.type == "pemasukan";
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isIncome
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              child: Icon(
                                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(
                              trx.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${trx.details}\n${DateFormat('dd MMM yyyy, HH:mm').format(trx.dateTime)}",
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: Text(
                              (isIncome ? "+Rp" : "-Rp") +
                                  NumberFormat("#,##0", "id_ID")
                                      .format(trx.amount.abs()),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
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
