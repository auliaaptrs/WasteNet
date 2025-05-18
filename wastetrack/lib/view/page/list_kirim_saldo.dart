import 'package:flutter/material.dart';
import 'package:wastetrack/view/main_tabview/main_tabview.dart';
import 'package:wastetrack/view/page/kirim_saldo.dart';

class ListKirimSaldoPage extends StatefulWidget {
  const ListKirimSaldoPage({super.key});

  @override
  State<ListKirimSaldoPage> createState() => _ListKirimSaldoPageState();
}

class _ListKirimSaldoPageState extends State<ListKirimSaldoPage> {
  int selectedTab = 0; // 0: Belum Terkirim, 1: Saldo Terkirim
  late int _selectedMonth;
  late int _selectedYear;
  String searchText = "";
  String get selectedMonthYear => "${_months[_selectedMonth - 1]} $_selectedYear";

  final List<String> _months = [
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

  final List<Map<String, dynamic>> belumTerkirim = [
    {
      'name': 'Bagus',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050301',
      'date': '2025-03-05 10:00:00',
      'amount': 'Rp30,000',
      'avatar': 'https://randomuser.me/api/portraits/men/11.jpg'
    },
    {
      'name': 'Putra',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050302',
      'date': '2025-03-12 11:00:00',
      'amount': 'Rp28,000',
      'avatar': 'https://randomuser.me/api/portraits/men/12.jpg'
    },
    {
      'name': 'Saroso',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050303',
      'date': '2025-03-19 14:00:00',
      'amount': 'Rp32,000',
      'avatar': 'https://randomuser.me/api/portraits/men/13.jpg'
    },

    {
      'name': 'Aubrey',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050501',
      'date': '2025-05-02 09:00:00',
      'amount': 'Rp35,000',
      'avatar': 'https://randomuser.me/api/portraits/women/42.jpg'
    },
    {
      'name': 'Rudi',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050502',
      'date': '2025-05-09 10:30:00',
      'amount': 'Rp31,000',
      'avatar': 'https://randomuser.me/api/portraits/men/15.jpg'
    },
    {
      'name': 'Dewi',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050503',
      'date': '2025-05-16 11:15:00',
      'amount': 'Rp29,000',
      'avatar': 'https://randomuser.me/api/portraits/women/32.jpg'
    },
    {
      'name': 'Joko',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050504',
      'date': '2025-05-23 13:45:00',
      'amount': 'Rp33,000',
      'avatar': 'https://randomuser.me/api/portraits/men/33.jpg'
    },
    {
      'name': 'Sari',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050505',
      'date': '2025-05-30 15:20:00',
      'amount': 'Rp27,000',
      'avatar': 'https://randomuser.me/api/portraits/women/34.jpg'
    },
  ];

  final List<Map<String, dynamic>> saldoTerkirim = [
    {
      'name': 'Putri',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050311',
      'date': '2025-03-07 08:30:00',
      'amount': 'Rp28,000',
      'avatar': 'https://randomuser.me/api/portraits/women/21.jpg'
    },
    {
      'name': 'Sinta',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050312',
      'date': '2025-03-14 12:45:00',
      'amount': 'Rp30,000',
      'avatar': 'https://randomuser.me/api/portraits/women/22.jpg'
    },
    {
      'name': 'Firda',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050313',
      'date': '2025-03-21 16:15:00',
      'amount': 'Rp34,000',
      'avatar': 'https://randomuser.me/api/portraits/women/23.jpg'
    },

    {
      'name': 'Mega',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050511',
      'date': '2025-05-05 10:00:00',
      'amount': 'Rp30,000',
      'avatar': 'https://randomuser.me/api/portraits/women/24.jpg'
    },
    {
      'name': 'Fajar',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050512',
      'date': '2025-05-12 11:30:00',
      'amount': 'Rp33,000',
      'avatar': 'https://randomuser.me/api/portraits/men/25.jpg'
    },
    {
      'name': 'Agus',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050513',
      'date': '2025-05-15 09:10:00',
      'amount': 'Rp32,000',
      'avatar': 'https://randomuser.me/api/portraits/men/41.jpg'
    },
    {
      'name': 'Rina',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050514',
      'date': '2025-05-18 14:20:00',
      'amount': 'Rp31,000',
      'avatar': 'https://randomuser.me/api/portraits/women/43.jpg'
    },
    {
      'name': 'Bambang',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050515',
      'date': '2025-05-22 08:45:00',
      'amount': 'Rp29,000',
      'avatar': 'https://randomuser.me/api/portraits/men/35.jpg'
    },
    {
      'name': 'Lina',
      'title': 'Pengiriman Tunai',
      'id': 'NSBI-25050516',
      'date': '2025-05-25 13:00:00',
      'amount': 'Rp27,000',
      'avatar': 'https://randomuser.me/api/portraits/women/31.jpg'
    },
    {
      'name': 'Dian',
      'title': 'Pengiriman Tunai',
      'id': 'NSBM-25050517',
      'date': '2025-05-28 16:30:00',
      'amount': 'Rp35,000',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg'
    },
  ];


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  // Filter list
  List<Map<String, dynamic>> get filteredList {
    final list = selectedTab == 0 ? belumTerkirim : saldoTerkirim;
    return list.where((item) {
      try {
        final date = DateTime.parse(item['date']);
        final matchesDate = date.month == _selectedMonth && date.year == _selectedYear;
        final matchesSearch = searchText.isEmpty ||
            item['name'].toString().toLowerCase().contains(searchText.toLowerCase());
        return matchesDate && matchesSearch;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  Future<void> _showMonthYearPicker() async {
    int tempMonth = _selectedMonth;
    int tempYear = _selectedYear;
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
                                  _months[idx],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.black : Colors.grey,
                                  ),
                                ),
                              );
                            },
                            childCount: _months.length,
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

  @override
  Widget build(BuildContext context) {
    final filtered = filteredList;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[100]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 18),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 28),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainTabView()),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Kirim Saldo',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: _showMonthYearPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Text(selectedMonthYear,
                                  style: const TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(width: 6),
                              Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Cari nama',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedTab = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedTab == 0 ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Belum Terkirim',
                                style: TextStyle(
                                  color: selectedTab == 0 ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedTab = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedTab == 1 ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Saldo Terkirim',
                                style: TextStyle(
                                  color: selectedTab == 1 ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[300]),
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      final isSent = selectedTab == 1;
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item['avatar']),
                            backgroundColor: isSent ? Colors.grey[300] : null,
                            foregroundColor: isSent ? Colors.grey : null,
                            child: isSent ? Opacity(opacity: 0.4, child: Icon(Icons.person)) : null,
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSent ? Colors.grey : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  color: isSent ? Colors.grey : Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                item['id'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                item['date'].substring(0, 10),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            item['amount'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSent ? Colors.grey : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            if (!isSent) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KirimSaldoPage(data: item),
                                ),
                              );
                            }
                          },
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
    );
  }
}
