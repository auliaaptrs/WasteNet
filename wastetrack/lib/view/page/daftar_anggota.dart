import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DaftarAnggotaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DaftarAnggotaPage extends StatefulWidget {
  const DaftarAnggotaPage({super.key});

  @override
  State<DaftarAnggotaPage> createState() => _DaftarAnggotaPageState();
}

class _DaftarAnggotaPageState extends State<DaftarAnggotaPage> {
  final List<Map<String, String>> anggota = List.generate(
    20,
        (index) {
      final label = (Random().nextBool()) ? 'NSBM' : 'NSBI';
      final number = (10000000 + Random().nextInt(90000000)).toString();
      return {
        "nama": [
          "Budi Sudirman", "Bagus Setiawan", "Siti Mawar", "Rina Dewi",
          "Andi Saputra", "Dewi Lestari", "Tono Prabowo", "Sari Utami",
          "Joko Santoso", "Maya Sari", "Firman Utina", "Lina Marlina",
          "Rudi Hartono", "Desi Ratnasari", "Agus Salim", "Nina Agustin",
          "Bambang Pamungkas", "Mega Putri", "Fajar Sidik", "Vina Ariani"
        ][index % 20],
        "id": "$label-$number",
        "tabungan": "Rp${(50 + Random().nextInt(10) * 50).toString()},000",
      };
    },
  );

  List<Map<String, String>> filteredAnggota = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredAnggota = anggota;
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredAnggota = anggota;
      });
      return;
    }
    setState(() {
      filteredAnggota = anggota.where((item) {
        final namaLower = item["nama"]!.toLowerCase();
        final idLower = item["id"]!.toLowerCase();
        final queryLower = query.toLowerCase();
        return namaLower.contains(queryLower) || idLower.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double namaWidth = 200;
    const double idWidth = 200;
    const double tabunganWidth = 200;
    const double colSpacing = 20;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDAF5E7), Color(0xFFEAF7F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 16, right: 12, bottom: 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 22,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Daftar Anggota",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 0, bottom: 0),
                child: Text(
                  "${filteredAnggota.length} Members",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: searchController,
                  onChanged: filterSearchResults,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: "Cari Nama atau ID",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: namaWidth + idWidth + tabunganWidth + colSpacing * 2 + 40,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  SizedBox(
                                    width: namaWidth,
                                    child: Text(
                                      "Nama",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                        fontSize: 15.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                      softWrap: false,
                                    ),
                                  ),
                                  SizedBox(width: colSpacing),
                                  SizedBox(
                                    width: idWidth,
                                    child: Text(
                                      "ID",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                        fontSize: 15.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                      softWrap: false,
                                    ),
                                  ),
                                  SizedBox(width: colSpacing),
                                  SizedBox(
                                    width: tabunganWidth,
                                    child: Text(
                                      "Total Tabungan",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                        fontSize: 15.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: filteredAnggota.isNotEmpty
                                  ? ListView.separated(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: filteredAnggota.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 0,
                                  color: Colors.grey.shade200,
                                ),
                                itemBuilder: (context, index) {
                                  final item = filteredAnggota[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: namaWidth,
                                          child: Text(
                                            item["nama"]!,
                                            style: const TextStyle(
                                              fontSize: 14.5,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        const SizedBox(width: colSpacing),
                                        SizedBox(
                                          width: idWidth,
                                          child: Text(
                                            item["id"]!,
                                            style: const TextStyle(
                                              fontSize: 14.5,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        const SizedBox(width: colSpacing),
                                        SizedBox(
                                          width: tabunganWidth,
                                          child: Text(
                                            item["tabungan"]!,
                                            style: const TextStyle(
                                              fontSize: 14.5,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                                  : const Center(
                                child: Text(
                                  "Data anggota tidak ditemukan",
                                  style: TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
