import 'package:flutter/material.dart';

class EditSampahPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditSampahPage({super.key, required this.item});

  @override
  State<EditSampahPage> createState() => _EditSampahPageState();
}

class _EditSampahPageState extends State<EditSampahPage> {
  late TextEditingController hargaController;
  late TextEditingController nameController;
  late String selectedJenis;
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item['name'] ?? '');
    hargaController = TextEditingController(text: widget.item['price']?.toString() ?? '');
    selectedJenis = widget.item['jenis'] ?? 'Kaleng';
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Anda Yakin?"),
        content: const Text("Perubahan belum disimpan. Jika keluar, data akan hilang."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Keluar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Batal"),
          ),
        ],
      ),
    ) ?? false;
  }

  void _updateData() {
    setState(() {
      isEdited = false;
      widget.item['price'] = int.tryParse(hargaController.text) ?? 0;
      widget.item['name'] = nameController.text;
      widget.item['jenis'] = selectedJenis;
    });
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!isEdited) {
          navigator.pop(false);
          return;
        }
        final exit = await _showExitConfirmationDialog();
        if (!mounted) return;
        if (exit) {
          navigator.pop(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (!isEdited) {
                navigator.pop(false);
                return;
              }
              final exit = await _showExitConfirmationDialog();
              if (!mounted) return;
              if (exit) {
                navigator.pop(false);
              }
            },
          ),
          title: const Text(
            "Edit Sampah",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        backgroundColor: const Color(0xFFF7F7FA),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (_) => setState(() => isEdited = true),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedJenis,
                decoration: const InputDecoration(
                  labelText: "Jenis Sampah",
                  border: OutlineInputBorder(),
                ),
                items: ['Kaleng', 'Plastik', 'Kertas'].map((jenis) {
                  return DropdownMenuItem(
                    value: jenis,
                    child: Text(jenis),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedJenis = val!;
                    isEdited = true;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga (Rp)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() => isEdited = true),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF101828),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
