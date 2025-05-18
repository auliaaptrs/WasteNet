import 'package:flutter/material.dart';
import 'edit_sampah.dart';
import 'tambah_sampah.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UbahHargaPage(),
  ));
}

class UbahHargaPage extends StatefulWidget {
  const UbahHargaPage({super.key});

  @override
  State<UbahHargaPage> createState() => _UbahHargaPageState();
}

class _UbahHargaPageState extends State<UbahHargaPage> {
  List<Map<String, dynamic>> items = [
    {
      "name": "Coca Cola Kaleng",
      "img": "assets/img/coke.png",
      "price": 5000,
      "jenis": "Kaleng",
      "description": "Sampah kaleng bekas minuman",
    },
    {
      "name": "Aqua 1,500 ml Botol Plastik PET",
      "img": "assets/img/Aqua.png",
      "price": 3000,
      "jenis": "Plastik",
      "description": "Botol plastik PET bekas",
    },
    {
      "name": "Vit 550 ml Botol Plastik PET",
      "img": "assets/img/vit.png",
      "price": 4000,
      "jenis": "Plastik",
      "description": "Botol plastik bekas minuman",
    },
    {
      "name": "Indomie Plastik",
      "img": "assets/img/indomie.png",
      "price": 3000,
      "jenis": "Plastik",
      "description": "Kemasan plastik Indomie",
    },

    {
      "name": "Indomie Plastik",
      "img": "assets/img/indomie.png",
      "price": 3000,
      "jenis": "Plastik",
      "description": "Kemasan plastik Indomie",
    },
    {
      "name": "Coca Cola Kaleng",
      "img": "assets/img/coke.png",
      "price": 5000,
      "jenis": "Kaleng",
      "description": "Sampah kaleng bekas minuman",
    },
    {
      "name": "Aqua 1,500 ml Botol Plastik PET",
      "img": "assets/img/Aqua.png",
      "price": 3000,
      "jenis": "Plastik",
      "description": "Botol plastik PET bekas",
    },
    {
      "name": "Vit 550 ml Botol Plastik PET",
      "img": "assets/img/vit.png",
      "price": 4000,
      "jenis": "Plastik",
      "description": "Botol plastik bekas minuman",
    },
    {
      "name": "Indomie Plastik",
      "img": "assets/img/indomie.png",
      "price": 3000,
      "jenis": "Plastik",
      "description": "Kemasan plastik Indomie",
    },
  ];

  List<Map<String, dynamic>> filteredItems = [];

  bool isSortDescending = true;
  bool isDeleteMode = false;
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    _sortItems();
    filteredItems = List.from(items);
  }

  void _sortItems() {
    items.sort((a, b) =>
    isSortDescending ? b['price'].compareTo(a['price']) : a['price'].compareTo(b['price']));
  }

  void _filterItems(String query) {
    final q = query.toLowerCase();
    setState(() {
      if (q.isEmpty) {
        filteredItems = List.from(items);
      } else {
        filteredItems = items.where((item) {
          final name = item['name'].toString().toLowerCase();
          return name.contains(q);
        }).toList();
      }

      selectedIndexes.clear();
      isDeleteMode = false;
    });
  }

  void _refreshItem(int index, Map<String, dynamic> updatedItem) {
    setState(() {
      items[index] = updatedItem;
      _sortItems();
      _filterItems('');
    });
  }

  void _addItem(Map<String, dynamic> newItem) {
    setState(() {
      items.add(newItem);
      _sortItems();
      _filterItems('');
    });
  }

  void _toggleSort() {
    setState(() {
      isSortDescending = !isSortDescending;
      _sortItems();
      _filterItems('');
    });
  }

  void _toggleDeleteMode() {
    setState(() {
      isDeleteMode = !isDeleteMode;
      selectedIndexes.clear();
    });
  }

  void _toggleSelectIndex(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      final sortedIndexes = selectedIndexes.toList()..sort((a, b) => b.compareTo(a));
      for (var index in sortedIndexes) {
        items.removeAt(index);
      }
      selectedIndexes.clear();
      isDeleteMode = false;
      _sortItems();
      _filterItems('');
    });
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: const Text(
          "Harga Sampah Saya",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _toggleDeleteMode,
            child: Text(
              isDeleteMode ? "Batal" : "Hapus",
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Tulis di Sini",
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      _filterItems(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _toggleSort,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF4CAF50)),
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isSortDescending
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: filteredItems.isEmpty
                  ? const Center(
                child: Text(
                  "Produk tidak ditemukan",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 12,
                childAspectRatio: 0.93,
                children: List.generate(filteredItems.length, (index) {
                  final item = filteredItems[index];
                  final originalIndex = items.indexOf(item);

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  item["img"],
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Rp${formatHarga(item["price"])}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "per Kg",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item["name"],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: isDeleteMode
                              ? Checkbox(
                            value: selectedIndexes.contains(originalIndex),
                            activeColor: Colors.green,
                            onChanged: (_) => _toggleSelectIndex(originalIndex),
                          )
                              : GestureDetector(
                            onTap: () async {
                              Map<String, dynamic> itemCopy = Map.from(item);
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditSampahPage(item: itemCopy),
                                ),
                              );
                              if (result == true) {
                                _refreshItem(originalIndex, itemCopy);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.edit, size: 18, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32, top: 4),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isDeleteMode
                    ? (selectedIndexes.isNotEmpty ? _deleteSelectedItems : null)
                    : () async {
                  final newItem = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahSampahPage(),
                    ),
                  );
                  if (newItem != null) {
                    _addItem(newItem);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDeleteMode ? Colors.black : const Color(0xFF101828),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isDeleteMode ? "Hapus Produk" : "Tambah Produk",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
