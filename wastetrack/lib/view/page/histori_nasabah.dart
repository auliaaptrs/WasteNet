import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wastetrack/view/main_tabview/maintab_nasabah_view.dart';
import 'package:wastetrack/view/page/data_sampah_nasabah.dart';

class HistoriNasabahPage extends StatefulWidget {
  const HistoriNasabahPage({super.key});
  @override
  State<HistoriNasabahPage> createState() => _HistoriNasabahPageState();
}

class _HistoriNasabahPageState extends State<HistoriNasabahPage> {
  int _selectedIndex = 1;
  String selectedFilter = 'Semua';

  int selectedMonth = 3;
  int selectedYear = 2025;

  final List<Map<String, dynamic>> transaksiDummy = [
    {
      'tanggal': DateTime(2025, 3, 20, 12, 0),
      'tipe': 'Penyetoran Sampah',
      'jumlah': 10000,
      'berat': 2,
    },
    {
      'tanggal': DateTime(2025, 3, 20, 12, 0),
      'tipe': 'Penarikan Saldo',
      'jumlah': -5000,
      'metode': 'Tunai',
    },
    {
      'tanggal': DateTime(2025, 3, 21, 10, 0),
      'tipe': 'Penyetoran Sampah',
      'jumlah': 7000,
      'berat': 2,
    },
    {
      'tanggal': DateTime(2025, 3, 22, 14, 0),
      'tipe': 'Penarikan Saldo',
      'jumlah': -8000,
      'metode': 'Tunai',
    },
    {
      'tanggal': DateTime(2025, 3, 23, 9, 0),
      'tipe': 'Penyetoran Sampah',
      'jumlah': 9000,
      'berat': 2,
    },
    {
      'tanggal': DateTime(2025, 5, 2, 13, 0),
      'tipe': 'Penyetoran Sampah',
      'jumlah': 5000,
      'berat': 4,
    },
    {
      'tanggal': DateTime(2025, 5, 10, 11, 0),
      'tipe': 'Penarikan Saldo',
      'jumlah': -3000,
      'metode': 'Tunai',
    },
    {
      'tanggal': DateTime(2025, 5, 16, 16, 0),
      'tipe': 'Penyetoran Sampah',
      'jumlah': 2000,
      'berat': 1,
    },
  ];

  List<Map<String, dynamic>> get transaksiBySelectedMonth {
    return transaksiDummy.where((item) =>
    item['tanggal'].month == selectedMonth &&
        item['tanggal'].year == selectedYear
    ).toList();
  }

  List<Map<String, dynamic>> get filteredTransaksi {
    final list = transaksiBySelectedMonth;
    if (selectedFilter == 'Semua') return list;
    return list.where((item) => item['tipe'] == selectedFilter).toList();
  }

  List<Map<String, dynamic>> get groupedChartData {
    final list = transaksiBySelectedMonth;
    Map<String, Map<String, dynamic>> grouped = {};
    for (var trx in list) {
      final tgl = DateTime(trx['tanggal'].year, trx['tanggal'].month, trx['tanggal'].day);
      final key = tgl.toIso8601String();
      grouped.putIfAbsent(key, () => {
        'tanggal': tgl,
        'setor': 0,
        'tarik': 0,
      });
      if (trx['tipe'] == 'Penyetoran Sampah') {
        grouped[key]!['setor'] += trx['jumlah'].abs();
      } else {
        grouped[key]!['tarik'] += trx['jumlah'].abs();
      }
    }
    final sorted = grouped.values.toList()
      ..sort((a, b) => a['tanggal'].compareTo(b['tanggal']));
    return sorted.length > 5 ? sorted.sublist(sorted.length - 5) : sorted;
  }

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainTabNasabahView()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WasteDetailNasabahPage()),
        );
        break;
    }
  }

  final List<Map<String, dynamic>> bulanList = [
    {'label': 'Maret 2025', 'month': 3, 'year': 2025},
    {'label': 'Mei 2025', 'month': 5, 'year': 2025},
  ];

  @override
  Widget build(BuildContext context) {
    final chartData = groupedChartData;
    final maxValue = chartData
        .map((e) => [e['setor'] as int, e['tarik'] as int])
        .expand((x) => x)
        .fold<int>(0, (prev, el) => el > prev ? el : prev);

    const double chartHeight = 100;
    const double garisBatas = 38;
    const double maxBarHeight = 28.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Histori Transaksi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF212529),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB7EACD), Color(0xFFF6F6F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB5EAD7), Color(0xFF96E3B8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.recycling, size: 32, color: Colors.black54),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                final result = await showDialog<Map<String, dynamic>>(
                                  context: context,
                                  builder: (_) => SimpleDialog(
                                    title: const Text('Pilih Bulan'),
                                    children: bulanList.map((b) => SimpleDialogOption(
                                      child: Text(b['label']),
                                      onPressed: () => Navigator.pop(context, b),
                                    )).toList(),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    selectedMonth = result['month'];
                                    selectedYear = result['year'];
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      bulanList.firstWhere((b) =>
                                      b['month'] == selectedMonth && b['year'] == selectedYear)['label'],
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.calendar_today, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: chartHeight,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: garisBatas,
                                        child: Container(
                                          height: 2,
                                          color: Colors.black26,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: List.generate(chartData.length, (i) {
                                            final e = chartData[i];
                                            final setor = e['setor'] as int;
                                            final tarik = e['tarik'] as int;
                                            final setorHeight = maxValue == 0 ? 0 : (setor / maxValue * maxBarHeight);
                                            final tarikHeight = maxValue == 0 ? 0 : (tarik / maxValue * maxBarHeight);

                                            return SizedBox(
                                              width: 44,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  if (setor > 0)
                                                    Positioned(
                                                      left: 6,
                                                      right: 6,
                                                      bottom: chartHeight - garisBatas,
                                                      height: setorHeight.toDouble(),
                                                      child: AnimatedContainer(
                                                        duration: const Duration(milliseconds: 300),
                                                        width: 42,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          gradient: const LinearGradient(
                                                            begin: Alignment.bottomCenter,
                                                            end: Alignment.topCenter,
                                                            colors: [
                                                              Color(0xFFB5EAD7),
                                                              Color(0xFF3A7E6C),
                                                            ],
                                                          ),
                                                          border: Border.all(
                                                            color: Color(0xFF3A7E6C),
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (tarik > 0)
                                                    Positioned(
                                                      left: 6,
                                                      right: 6,
                                                      top: garisBatas,
                                                      height: tarikHeight.toDouble(),
                                                      child: AnimatedContainer(
                                                        duration: const Duration(milliseconds: 300),
                                                        width: 42,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          gradient: const LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [
                                                              Color(0xFFB5EAD7),
                                                              Color(0xFF3A7E6C),
                                                            ],
                                                          ),
                                                          border: Border.all(
                                                            color: Color(0xFF3A7E6C),
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  Positioned(
                                                    left: 0,
                                                    right: 0,
                                                    bottom: -7,
                                                    child: Text(
                                                      _formatTanggal(e['tanggal']),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 90,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      top: 6,
                                      child: Text(
                                        'Penyetoran\nSampah',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF3A7E6C),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      top: garisBatas + 8,
                                      child: Text(
                                        'Penarikan\nTunai',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF51C17C),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Semua'),
                          selected: selectedFilter == 'Semua',
                          onSelected: (_) => setState(() => selectedFilter = 'Semua'),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Penyetoran Sampah'),
                          selected: selectedFilter == 'Penyetoran Sampah',
                          onSelected: (_) => setState(() => selectedFilter = 'Penyetoran Sampah'),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Penarikan Saldo'),
                          selected: selectedFilter == 'Penarikan Saldo',
                          onSelected: (_) => setState(() => selectedFilter = 'Penarikan Saldo'),
                        ),
                      ],
                    ),
                  ),
                ),
                // LIST TRANSAKSI
                Expanded(
                  child: filteredTransaksi.isEmpty
                      ? const Center(child: Text('Belum ada transaksi pada bulan ini.'))
                      : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: filteredTransaksi.length,
                    itemBuilder: (context, index) {
                      final transaksi = filteredTransaksi[index];
                      return _buildTransaksiCard(transaksi);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildTransaksiCard(Map<String, dynamic> transaksi) {
    bool isPenyetoran = transaksi['tipe'] == 'Penyetoran Sampah';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFB5EAD7),
            child: Icon(
              isPenyetoran ? Icons.add_card : Icons.account_balance_wallet,
              color: Colors.green.shade700,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi['tipe'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (isPenyetoran && transaksi['berat'] != null)
                  Text('${transaksi['berat']} Kg',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500)),
                if (!isPenyetoran && transaksi['metode'] != null)
                  Text(
                    transaksi['metode'],
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                const Text('Rincian Transaksi →',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(
                  _formatTanggalFull(transaksi['tanggal']),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            (transaksi['jumlah'] > 0
                ? '+Rp${_formatRupiah(transaksi['jumlah'])}'
                : '-Rp${_formatRupiah(transaksi['jumlah'].abs())}'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaksi['jumlah'] > 0
                  ? Colors.green.shade700
                  : Colors.red.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(DateTime dt) {
    final bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${dt.day} ${bulan[dt.month]}';
  }

  String _formatTanggalFull(DateTime dt) {
    final bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${dt.day} ${bulan[dt.month]} ${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String _formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
