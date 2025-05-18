import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TambahSampahPage extends StatefulWidget {
  const TambahSampahPage({super.key});

  @override
  State<TambahSampahPage> createState() => _TambahSampahPageState();
}

class _TambahSampahPageState extends State<TambahSampahPage> {
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedJenis = 'Kaleng';
  File? _imageFile;
  bool isEdited = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        isEdited = true;
      });
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Anda Yakin?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                "Perubahan belum disimpan. Jika keluar, data akan hilang.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF101828),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Simpan', style: TextStyle(color: Color(0xFF3DB39B), fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ??
        false;
  }

  void _onSimpan() {
    final harga = int.tryParse(hargaController.text) ?? 0;
    final nama = nameController.text.trim();
    final newItem = {
      "name": nama,
      "img": _imageFile?.path ?? "",
      "price": harga,
      "jenis": selectedJenis,

    };
    Navigator.of(context).pop(newItem);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!isEdited) {
          navigator.pop();
          return;
        }
        final exit = await _showExitConfirmationDialog();
        if (!mounted) return;
        if (exit) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (!isEdited) {
                    navigator.pop();
                    return;
                  }
                  final exit = await _showExitConfirmationDialog();
                  if (!mounted) return;
                  if (exit) {
                    navigator.pop();
                  }
                },
              ),
            ),
          ),
          title: const Text(
            "Tambah Sampah",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Tambahkan Nama",
                        border: const OutlineInputBorder(),
                        isDense: true,
                        suffixIcon: Icon(Icons.edit, size: 18, color: Colors.grey[400]),
                      ),
                      onChanged: (_) => setState(() => isEdited = true),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedJenis,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color(0xFFF7F7FA),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: ['Kaleng', 'Plastik', 'Kertas'].map((jenis) {
                        return DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis, style: const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedJenis = val!;
                          isEdited = true;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    // Harga
                    Row(
                      children: [
                        const Text("Rp", style: TextStyle(color: Colors.grey, fontSize: 16)),
                        const SizedBox(width: 2),
                        Expanded(
                          child: TextField(
                            controller: hargaController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Isi Harga Jual",
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            ),
                            onChanged: (_) => setState(() => isEdited = true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("per Kg", style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Gambar
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 120,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7FA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: _imageFile == null
                                ? const Icon(Icons.add, size: 36, color: Colors.grey)
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextButton(
                                onPressed: _imageFile == null
                                    ? null
                                    : () {
                                  setState(() {
                                    _imageFile = null;
                                    isEdited = true;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  disabledForegroundColor: Colors.grey[400],
                                ),
                                child: const Text("Hapus Gambar"),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF101828),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                onPressed: _pickImage,
                                child: const Text("Edit Gambar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSimpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF101828),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
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
