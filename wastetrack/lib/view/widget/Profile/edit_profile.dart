import 'package:flutter/material.dart';
import 'package:wastetrack/global/banksampahprofile.dart';


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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? provinsi;
  String? kota;
  String? kecamatan;
  String? kelurahan;
  late TextEditingController institusiController;
  late TextEditingController penanggungJawabController;
  late TextEditingController alamatController;
  late TextEditingController kapasitasController;

  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    final profile = bankSampahProfile;
    institusiController = TextEditingController(text: profile?.namaBank ?? '');
    penanggungJawabController = TextEditingController(text: profile?.namaPJ ?? '');
    alamatController = TextEditingController(text: profile?.alamat ?? '');
    kapasitasController = TextEditingController(text: profile?.kapasitas.toString() ?? '');

    provinsi = profile?.provinsi;
    kota = profile?.kota;
    kecamatan = profile?.kecamatan;
    kelurahan = profile?.kelurahan;

    institusiController.addListener(() => setState(() => isChanged = true));
    penanggungJawabController.addListener(() => setState(() => isChanged = true));
    alamatController.addListener(() => setState(() => isChanged = true));
    kapasitasController.addListener(() => setState(() => isChanged = true));
  }

  @override
  void dispose() {
    institusiController.dispose();
    penanggungJawabController.dispose();
    alamatController.dispose();
    kapasitasController.dispose();
    super.dispose();
  }

  List<String> getProvinsi() => provinsiToKota.keys.toList();
  List<String> getKota() => provinsi != null ? provinsiToKota[provinsi!] ?? [] : [];
  List<String> getKecamatan() => kota != null ? kotaToKecamatan[kota!] ?? [] : [];
  List<String> getKelurahan() => kecamatan != null ? kecamatanToKelurahan[kecamatan!] ?? [] : [];

  void setProvinsi(String? newVal) {
    setState(() {
      provinsi = newVal;
      kota = null;
      kecamatan = null;
      kelurahan = null;
      isChanged = true;
    });
  }

  void setKota(String? newVal) {
    setState(() {
      kota = newVal;
      kecamatan = null;
      kelurahan = null;
      isChanged = true;
    });
  }

  void setKecamatan(String? newVal) {
    setState(() {
      kecamatan = newVal;
      kelurahan = null;
      isChanged = true;
    });
  }

  void setKelurahan(String? newVal) {
    setState(() {
      kelurahan = newVal;
      isChanged = true;
    });
  }

  void updateLocalProfile() {
    if (kapasitasController.text.isEmpty || int.tryParse(kapasitasController.text) == null) {
      showErrorMessage('Kapasitas harus berupa angka');
      return;
    }

    bankSampahProfile = bankSampahProfile?.copyWith(
      namaBank: institusiController.text,
      namaPJ: penanggungJawabController.text,
      alamat: alamatController.text,
      kelurahan: kelurahan,
      kecamatan: kecamatan,
      kota: kota,
      provinsi: provinsi,
      kapasitas: int.parse(kapasitasController.text),
    );

    showSuccessDialog();
    setState(() => isChanged = false);
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          "Perubahan berhasil disimpan (lokal)!",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<bool> onBackPressed() async {
    if (isChanged) {
      bool confirmExit = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Perubahan Belum Disimpan"),
          content: const Text("Anda yakin ingin keluar tanpa menyimpan perubahan?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Keluar"),
            ),
          ],
        ),
      );
      return confirmExit;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final profile = bankSampahProfile;
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB6F2C5), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 32),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () async {
                                bool canPop = await onBackPressed();
                                if (canPop) Navigator.pop(context);
                              },
                            ),
                            const Text(
                              'Edit Profil',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.black),
                              onPressed: updateLocalProfile,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.purple[100],
                          child: const Icon(Icons.person, color: Colors.white, size: 56),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            side: BorderSide(color: Colors.grey.shade400),
                          ),
                          child: const Text('Ubah Gambar'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 6, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ProfileField(
                          icon: Icons.account_balance,
                          label: 'Peran',
                          value: 'Bank Sampah Unit',
                          readOnly: true,
                          locked: true,
                        ),
                        _ProfileField(
                          icon: Icons.badge_outlined,
                          label: 'ID Pengguna',
                          value: profile?.bankId ?? '',
                          readOnly: true,
                          locked: true,
                        ),
                        _ProfileField(
                          icon: Icons.apartment_outlined,
                          label: 'Nama Institusi',
                          controller: institusiController,
                          bold: true,
                        ),
                        _ProfileField(
                          icon: Icons.person_outline,
                          label: 'Nama Penanggung Jawab',
                          controller: penanggungJawabController,
                          bold: true,
                        ),
                        _ProfileField(
                          icon: Icons.scale_outlined,
                          label: 'Kapasitas (Kg)',
                          controller: kapasitasController,
                          keyboardType: TextInputType.number,
                        ),
                        _DropdownField(
                          icon: Icons.map_outlined,
                          label: 'Provinsi',
                          value: provinsi,
                          items: getProvinsi(),
                          onChanged: setProvinsi,
                        ),
                        _DropdownField(
                          icon: Icons.location_city_outlined,
                          label: 'Kota/Kabupaten',
                          value: kota,
                          items: getKota(),
                          onChanged: setKota,
                        ),
                        _DropdownField(
                          icon: Icons.location_on,
                          label: 'Kecamatan',
                          value: kecamatan,
                          items: getKecamatan(),
                          onChanged: setKecamatan,
                        ),
                        _DropdownField(
                          icon: Icons.home_work_outlined,
                          label: 'Kelurahan',
                          value: kelurahan,
                          items: getKelurahan(),
                          onChanged: setKelurahan,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: alamatController,
                                    decoration: const InputDecoration(
                                      labelText: 'Alamat',
                                      labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 1, thickness: 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool readOnly;
  final bool locked;
  final bool bold;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const _ProfileField({
    Key? key,
    required this.icon,
    required this.label,
    this.value,
    this.readOnly = false,
    this.locked = false,
    this.bold = false,
    this.controller,
    this.onChanged,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: Colors.black87,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: controller != null
                  ? TextField(
                controller: controller,
                readOnly: readOnly || locked,
                style: textStyle,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: onChanged,
              )
                  : TextField(
                controller: TextEditingController(text: value),
                readOnly: readOnly || locked,
                style: textStyle,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: onChanged,
              ),
            ),
            if (locked) const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
          ],
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: value,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                items: items
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
