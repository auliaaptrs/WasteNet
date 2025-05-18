import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wastetrack/global/userprofile.dart';
import 'package:wastetrack/models/userprofile.dart';
import 'package:wastetrack/view/login/login_view.dart';

class RegisNasabahView extends StatefulWidget {
  final String peran;
  final String email;
  final String userId;

  const RegisNasabahView({
    super.key,
    required this.peran,
    required this.email,
    required this.userId,
  });

  @override
  State<RegisNasabahView> createState() => _RegisNasabahViewState();
}

class _RegisNasabahViewState extends State<RegisNasabahView> {
  bool get isInstitusi => widget.peran.toLowerCase().contains('institusi');
  bool get isMandiri => widget.peran.toLowerCase().contains('mandiri');

  final TextEditingController namaController = TextEditingController();
  final TextEditingController institusiController = TextEditingController();
  final TextEditingController alamatJalanController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController bankSampahIdController = TextEditingController();
  bool bankSampahIdChecked = false;
  String? bankSampahIdError;


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

  final Map<String, List<String>> bankSampahPerKelurahan = {
    'Hegarmanah': ['Bank Sampah Melati', 'Bank Sampah Mawar'],
    'Lebakgede': ['Bank Sampah Kenanga'],
    'Dago': ['Bank Sampah Anggrek', 'Bank Sampah Dahlia'],
    'Sukajadi': ['Bank Sampah Melati'],
    'Leuwigajah': ['Bank Sampah Mawar', 'Bank Sampah Kenanga'],
    'Baros': ['Bank Sampah Dahlia'],
    'Cibeureum': ['Bank Sampah Anggrek'],
    'Melong': ['Bank Sampah Melati'],
    'Sukolilo Baru': ['Bank Sampah Mawar'],
    'Sukolilo Lama': ['Bank Sampah Kenanga'],
    'Jagir': ['Bank Sampah Dahlia'],
    'Gubeng': ['Bank Sampah Anggrek'],
    'Rampal Celaket': ['Bank Sampah Melati'],
    'Rampal Sari': ['Bank Sampah Mawar'],
    'Ketawanggede': ['Bank Sampah Kenanga'],
    'Tlogomas': ['Bank Sampah Dahlia'],
    'Gandaria Selatan': ['Bank Sampah Anggrek'],
    'Pulo': ['Bank Sampah Melati'],
    'Tegal Parang': ['Bank Sampah Mawar'],
    'Kuningan Barat': ['Bank Sampah Kenanga'],
    'Sunda Kelapa': ['Bank Sampah Dahlia'],
    'Rawa Badak': ['Bank Sampah Anggrek'],
    'Pegangsaan Dua': ['Bank Sampah Melati'],
    'Kelapa Gading Barat': ['Bank Sampah Mawar'],
  };

  String? selectedProvinsi;
  String? selectedKota;
  String? selectedKecamatan;
  String? selectedKelurahan;

  List<String> kotaList = [];
  List<String> kecamatanList = [];
  List<String> kelurahanList = [];

  bool sudahAnggota = false;
  String? selectedBankSampah;
  List<String> daftarBankKelurahan = [];


  final List<String> bankSampahList = [
    "Bank Sampah Melati",
    "Bank Sampah Mawar",
    "Bank Sampah Kenanga",
    "Bank Sampah Dahlia",
    "Bank Sampah Anggrek",
  ];

  @override
  void dispose() {
    namaController.dispose();
    alamatJalanController.dispose();
    teleponController.dispose();
    institusiController.dispose();
    super.dispose();
  }

  List<String> _getBankSampahByKelurahan(String kelurahan) {
    return bankSampahPerKelurahan[kelurahan] ?? [];
  }

  void _onSave() async {

    if (namaController.text.isEmpty ||
        teleponController.text.isEmpty ||
        selectedProvinsi == null ||
        selectedKota == null ||
        selectedKecamatan == null ||
        selectedKelurahan == null ||
        alamatJalanController.text.isEmpty ||
        (isInstitusi && institusiController.text.isEmpty)
    ) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }


    if (sudahAnggota) {
      if (bankSampahIdController.text.trim().isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan kode ID bank sampah!')),
        );
        return;
      }
      if (!bankSampahIdChecked) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tekan tombol cek untuk validasi kode bank sampah!')),
        );
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil, silakan login')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
      );
      return;
    }

    userProfile = UserProfile(
      name: namaController.text,
      id: widget.userId,
      role: widget.peran,
      email: widget.email,
      phone: teleponController.text,
      province: selectedProvinsi!,
      city: selectedKota!,
      district: selectedKecamatan!,
      subdistrict: selectedKelurahan!,
      address: alamatJalanController.text,
      institusi: isInstitusi
          ? institusiController.text
          : "Mandiri",
    );



    await _showBankSampahFlow();
  }

  Future<void> _showBankSampahFlow() async {
    String? chosenBank;
    List<String> rekomendasiList = _getBankSampahByKelurahan(selectedKelurahan ?? "");
    if (rekomendasiList.isEmpty) {
      rekomendasiList = bankSampahList;
    }
    int currentIndex = 0;
    String recommendedBank = rekomendasiList[currentIndex];

    while (chosenBank == null) {
      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white,
        transitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, anim1, anim2) {
          Timer(const Duration(seconds: 2), () {
            if (!mounted) return;
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
          return const _PencarianOverlay();
        },
      );

      if (!mounted) return;

      bool? setuju = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _RekomendasiBankPopup(namaBank: recommendedBank),
      );

      if (!mounted) return;

      if (setuju == true) {
        chosenBank = recommendedBank;
      } else {
        currentIndex++;
        if (currentIndex >= rekomendasiList.length) {
          currentIndex = 0;
        }
        recommendedBank = rekomendasiList[currentIndex];
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil, silakan login')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final String labelNama = isInstitusi ? "Nama Penanggung Jawab" : "Nama";
    final String hintNama = "Bagus Setiabudi";

    final String labelAlamat = isInstitusi ? "Alamat Institusi" : "Alamat";
    final String hintAlamat = "Jalan Bagus Setiabudi No.100";

    final String labelTelepon = isInstitusi ? "Nomor Telepon Penanggung Jawab" : "Nomor Telepon";
    final String hintTelepon = "0811234567890";

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

                  Text(
                    "Institusi",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: isInstitusi
                        ? institusiController
                        : TextEditingController(text: "Mandiri"),
                    enabled: isInstitusi,
                    readOnly: !isInstitusi,
                    decoration: InputDecoration(
                      hintText: isInstitusi ? "SDIT AL-Hikmah" : "Mandiri",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    labelNama,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      hintText: hintNama,
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
                              "Provinsi",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: selectedProvinsi,
                              hint: const Text("Tulis di Sini"),
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
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
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
                              hint: const Text("Tulis di Sini"),
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
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
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
                              hint: const Text("Tulis di Sini"),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  if (sudahAnggota && selectedKelurahan != null) {
                                    daftarBankKelurahan = _getBankSampahByKelurahan(selectedKelurahan!);
                                    selectedBankSampah = null;
                                  }
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

                  Text(
                    labelAlamat,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: alamatJalanController,
                    decoration: InputDecoration(
                      hintText: hintAlamat,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    labelTelepon,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: teleponController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: hintTelepon,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  CheckboxListTile(
                    value: sudahAnggota,
                    onChanged: (val) {
                      setState(() {
                        sudahAnggota = val ?? false;
                        if (!sudahAnggota) {
                          daftarBankKelurahan = [];
                          selectedBankSampah = null;
                        } else if (selectedKelurahan != null) {
                          daftarBankKelurahan = _getBankSampahByKelurahan(selectedKelurahan!);
                        }
                      });
                    },
                    title: const Text("Sudah jadi anggota Bank Sampah"),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  ),

                  if (sudahAnggota)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kode ID Bank Sampah",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: bankSampahIdController,
                                decoration: InputDecoration(
                                  hintText: "Masukkan kode ID bank sampah",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  errorText: bankSampahIdError,
                                ),
                                onChanged: (_) {
                                  setState(() {
                                    bankSampahIdError = null;
                                    bankSampahIdChecked = false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (bankSampahIdController.text.trim().isEmpty) {
                                    bankSampahIdError = "Wajib diisi";
                                    bankSampahIdChecked = false;
                                  } else {
                                    bankSampahIdError = null;
                                    bankSampahIdChecked = true;
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: bankSampahIdChecked ? Colors.green : Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  bankSampahIdChecked ? Icons.check : Icons.check_box_outline_blank,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),


                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
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
    this.textColor = Colors.black,
    this.iconColor = Colors.black54,
    this.lockColor = Colors.black38,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: lockColor)),
                Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
              ],
            ),
          ),
          const Icon(Icons.lock, size: 18, color: Colors.black38),
        ],
      ),
    );
  }
}

class _PencarianOverlay extends StatelessWidget {
  const _PencarianOverlay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/img/Pencarian.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _RekomendasiBankPopup extends StatelessWidget {
  final String namaBank;
  const _RekomendasiBankPopup({required this.namaBank});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$namaBank ",
                    style: const TextStyle(
                      color: Color(0xFF3BA16D),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const TextSpan(
                    text: "Cocok untuk Anda\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const TextSpan(
                    text: "Apakah Anda setuju dengan rekomendasi tersebut?",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cari Lagi
                  },
                  child: const Text(
                    "Cari Lagi",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Setuju",
                    style: TextStyle(
                      color: Color(0xFF3BA16D),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}