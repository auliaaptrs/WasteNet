import 'package:flutter/material.dart';
import 'package:wastetrack/view/login/login_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisView extends StatefulWidget {
  final String peran;
  final String email;
  final String userId;

  const RegisView({
    super.key,
    required this.peran,
    required this.email,
    required this.userId,
  });

  @override
  State<RegisView> createState() => _RegisViewState();
}

class _RegisViewState extends State<RegisView> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatJalanController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();
  final TextEditingController penanggungJawabController = TextEditingController();

  final Map<String, List<String>> provinsiToKota = {
    'Jawa Barat': ['Bandung', 'Cimahi'],
    'Jawa Timur': ['Surabaya', 'Malang'],
    'DKI Jakarta': ['Jakarta Selatan', 'Jakarta Utara'],
  };

  final Map<String, List<String>> kotaToKecamatan = {
    'Bandung': ['Cidadap', 'Coblong'],
    'Cimahi': ['Cimahi Selatan', 'Cimahi Tengah'],
    'Surabaya': ['Sukolilo', 'Wonokromo'],
    'Malang': ['Klojen', 'Lowokwaru'],
    'Jakarta Selatan': ['Kebayoran Baru', 'Mampang'],
    'Jakarta Utara': ['Tanjung Priok', 'Kelapa Gading'],
  };

  final Map<String, List<String>> kecamatanToKelurahan = {
    'Cidadap': ['Hegarmanah', 'Lebakgede'],
    'Coblong': ['Dago', 'Sukajadi'],
    'Cimahi Selatan': ['Leuwigajah', 'Baros'],
    'Cimahi Tengah': ['Cibeureum', 'Melong'],
    'Sukolilo': ['Keputih', 'Gebang'],
    'Wonokromo': ['Jagir', 'Gubeng'],
    'Klojen': ['Rampal Celaket', 'Rampal Sari'],
    'Lowokwaru': ['Ketawanggede', 'Tlogomas'],
    'Kebayoran Baru': ['Gandaria Selatan', 'Pulo'],
    'Mampang': ['Tegal Parang', 'Kuningan Barat'],
    'Tanjung Priok': ['Sunda Kelapa', 'Rawa Badak'],
    'Kelapa Gading': ['Pegangsaan Dua', 'Kelapa Gading Barat'],
  };

  String? selectedProvinsi;
  String? selectedKota;
  String? selectedKecamatan;
  String? selectedKelurahan;

  List<String> kotaList = [];
  List<String> kecamatanList = [];
  List<String> kelurahanList = [];

  String satuanKapasitas = 'Kg';
  @override
  void dispose() {
    namaController.dispose();
    alamatJalanController.dispose();
    teleponController.dispose();
    kapasitasController.dispose();
    penanggungJawabController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (namaController.text.trim().isEmpty ||
        teleponController.text.trim().isEmpty ||
        selectedProvinsi == null ||
        selectedKota == null ||
        selectedKecamatan == null ||
        selectedKelurahan == null ||
        alamatJalanController.text.trim().isEmpty ||
        kapasitasController.text.trim().isEmpty ||
        penanggungJawabController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );


    final data = {
      "bank_id": widget.userId,
      "nama_bank": namaController.text.trim(),
      "nama_pj": penanggungJawabController.text.trim(),
      "telepon": teleponController.text.trim(),
      "alamat": alamatJalanController.text.trim(),
      "kelurahan": selectedKelurahan!,
      "kecamatan": selectedKecamatan!,
      "kota": selectedKota!,
      "provinsi": selectedProvinsi!,
      "kapasitas": int.parse(kapasitasController.text.trim()),
    };


    try {
      final response = await http.post(
        Uri.parse('https://be-wastetrack-userservice-879904203531.us-central1.run.app/BankSampah/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil, silakan login')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal: ${response.body}')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String namaInstitusiHint;
    switch (widget.peran) {
      case "Bank Sampah Induk":
        namaInstitusiHint = "Bank Sampah Induk Surabaya";
        break;
      case "Bank Sampah Unit":
        namaInstitusiHint = "Bank Sampah Mawar";
        break;
      case "TPS 3R":
        namaInstitusiHint = "TPS 3R Karangpilang";
        break;
      case "TPS Non-3R":
        namaInstitusiHint = "TPS Tambak Rejo";
        break;
      default:
        namaInstitusiHint = "Nama Institusi";
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/login_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Lengkapi Data!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _DisabledField(
                    icon: Icons.person_outline,
                    label: "Peran",
                    value: widget.peran,
                    textColor: Colors.black,
                    iconColor: Colors.black54,
                    lockColor: Colors.black38,
                  ),
                  const SizedBox(height: 12),
                  _DisabledField(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: widget.email,
                    textColor: Colors.black,
                    iconColor: Colors.black54,
                    lockColor: Colors.black38,
                  ),
                  const SizedBox(height: 12),
                  _DisabledField(
                    icon: Icons.assignment_ind_outlined,
                    label: "ID Pengguna",
                    value: widget.userId,
                    textColor: Colors.black,
                    iconColor: Colors.black54,
                    lockColor: Colors.black38,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Nama Institusi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      hintText: namaInstitusiHint,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Provinsi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedProvinsi,
                    hint: const Text("Pilih Provinsi"),
                    items: provinsiToKota.keys
                        .map((prov) => DropdownMenuItem(value: prov, child: Text(prov)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProvinsi = value;
                        selectedKota = null;
                        selectedKecamatan = null;
                        selectedKelurahan = null;
                        kotaList = value != null ? provinsiToKota[value]! : [];
                        kecamatanList = [];
                        kelurahanList = [];
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kota/Kabupaten",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: selectedKota,
                              hint: const Text("Pilih Kota"),
                              items: kotaList
                                  .map((kota) => DropdownMenuItem(value: kota, child: Text(kota)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedKota = value;
                                  selectedKecamatan = null;
                                  selectedKelurahan = null;
                                  kecamatanList = value != null ? kotaToKecamatan[value]! : [];
                                  kelurahanList = [];
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kecamatan",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: selectedKecamatan,
                              hint: const Text("Pilih Kecamatan"),
                              items: kecamatanList
                                  .map((kec) => DropdownMenuItem(value: kec, child: Text(kec)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedKecamatan = value;
                                  selectedKelurahan = null;
                                  kelurahanList = value != null ? kecamatanToKelurahan[value]! : [];
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Kelurahan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedKelurahan,
                    hint: const Text("Pilih Kelurahan"),
                    items: kelurahanList
                        .map((kel) => DropdownMenuItem(value: kel, child: Text(kel)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedKelurahan = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Alamat Jalan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: alamatJalanController,
                    decoration: InputDecoration(
                      hintText: "Masukkan alamat jalan",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "No. Telepon",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: teleponController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Masukkan nomor telepon",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Kapasitas",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: kapasitasController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Masukkan kapasitas",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Text(
                          'Kg',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Penanggung Jawab",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: penanggungJawabController,
                    decoration: InputDecoration(
                      hintText: "Masukkan nama penanggung jawab",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisabledField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color iconColor;
  final Color lockColor;

  const _DisabledField({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
    required this.iconColor,
    required this.lockColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(value, style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Icon(Icons.lock, color: lockColor, size: 18),
        ],
      ),
    );
  }
}
