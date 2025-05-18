import 'package:flutter/material.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> notifikasiTerkirim = [
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Penarikan Disetujui!',
      'desc': 'Permintaan penarikan tunai oleh Bagus\nID-123-456-789-00 senilai Rp20,250 telah Anda setujui',
      'date': '12 Mar 2025 12:00',
      'status': 'disetujui',
    },
    {
      'icon': Icons.eco,
      'title': 'Penyetoran Sampah Berhasil!',
      'desc': 'Penyetoran Sampah oleh Bagus ID-123-456-789-00 senilai Rp20,250 telah berhasil',
      'date': '12 Mar 2025 12:00',
      'status': 'berhasil',
    },
  ];

  final List<Map<String, dynamic>> notifikasiDiterima = [
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Permintaan Penarikan!',
      'desc': 'Permintaan penarikan tunai oleh Bagus\nID-123-456-789-00 senilai Rp20,250',
      'date': '12 Mar 2025 12:00',
      'status': 'belum_disetujui',
    },
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Permintaan Penarikan!',
      'desc': 'Permintaan penarikan tunai oleh Bagus\nID-123-456-789-00 senilai Rp20,250',
      'date': '12 Mar 2025 12:00',
      'status': 'normal',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: const [
                Text(
                  'Maret 2025',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(width: 6),
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.black),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search, color: Colors.grey, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Cari ID',
                            hintStyle: TextStyle(color: Colors.grey),
                            isDense: true,
                          ),
                          onChanged: (val) => setState(() => searchQuery = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Pesan Terkirim'),
                    Tab(text: 'Pesan Diterima'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pesan Terkirim
          _NotifList(
            list: notifikasiTerkirim.where((notif) {
              if (searchQuery.isEmpty) return true;
              return notif['desc'].toString().toLowerCase().contains(searchQuery.toLowerCase());
            }).toList(),
            isTerkirim: true,
          ),
          // Pesan Diterima
          _NotifList(
            list: notifikasiDiterima.where((notif) {
              if (searchQuery.isEmpty) return true;
              return notif['desc'].toString().toLowerCase().contains(searchQuery.toLowerCase());
            }).toList(),
            isTerkirim: false,
          ),
        ],
      ),
    );
  }
}

class _NotifList extends StatelessWidget {
  final List<Map<String, dynamic>> list;
  final bool isTerkirim;

  const _NotifList({required this.list, required this.isTerkirim});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("Tidak ada notifikasi."));
    }
    return ListView.separated(
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(vertical: 12),
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, i) {
        final notif = list[i];
        Color? tileColor;
        Widget? trailing;

        if (isTerkirim && (notif['status'] == 'disetujui' || notif['status'] == 'berhasil')) {
          tileColor = const Color(0xFFDFF7E6);
        } else if (!isTerkirim && notif['status'] == 'belum_disetujui') {
          tileColor = const Color(0xFFDFF7E6);
          trailing = Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Belum Disetujui',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          );
        }

        return Container(
          color: tileColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(notif['icon'] ?? Icons.notifications, color: Colors.green[900], size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          notif['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (trailing != null) trailing,
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notif['desc'],
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notif['date'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
