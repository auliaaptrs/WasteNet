import 'package:flutter/material.dart';
import 'package:wastetrack/view/login/sign_up_view.dart';

class InformasiPeranView extends StatefulWidget {
  const InformasiPeranView({super.key});

  @override
  State<InformasiPeranView> createState() => _InformasiPeranViewState();
}

class _InformasiPeranViewState extends State<InformasiPeranView> {
  final List<Map<String, String>> roles = [
    {
      'title': 'Nasabah Individu',
      'desc': 'Orang atau perorangan yang menyetor sampah.\n(Contoh: Ibu rumah tangga, dan lainnya).',
      'icon': 'assets/img/NasabahIndividu_info.png',
    },
    {
      'title': 'TPS Non-3R',
      'desc': 'Tempat pengumpulan sampah sementara sebelum diproses lebih lanjut.',
      'icon': 'assets/img/TPSnon3R_info.png',
    },
    {
      'title': 'Nasabah Institusi',
      'desc': 'Organisasi atau lembaga yang menyetor sampah dalam jumlah besar.\n(Contoh: Sekolah, UMKM, restoran, dan lainnya).',
      'icon': 'assets/img/NasabahInstitusi_info.png',
    },
    {
      'title': 'TPS 3R',
      'desc': 'TPS yang mengolah sampah berdasarkan prinsip 3R (Mengurangi, Menggunakan Kembali, Daur Ulang).',
      'icon': 'assets/img/TPS3R_info.png',
    },
    {
      'title': 'Bank Sampah Unit',
      'desc': 'Organisasi lingkup kecil (RT, RW, Kecamatan) yang mengumpulkan sampah dari nasabah untuk diproses dan disalurkan, serta terhubung dengan Bank Sampah Induk.',
      'icon': 'assets/img/BankSampahUnit_info.png',
    },
    {
      'title': 'Bank Sampah Induk',
      'desc': 'Pusat pengelolaan sampah yang mengkoordinasikan dan menghubungkan beberapa bank sampah unit.',
      'icon': 'assets/img/BankSampahInduk_info.png',
    },
  ];

  void showRoleDialog(String title, String desc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: media.width,
            height: media.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE6F4EA), Color(0xFFD7F3E3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Klik dan Pastikan Peran Anda di Bawah Ini!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Cermati dan pilih peran Anda, agar kebutuhan dan kontribusi Anda dapat terpenuhi secara maksimal",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(roles.length, (index) {
                        final role = roles[index];
                        return GestureDetector(
                          onTap: () => showRoleDialog(role['title']!, role['desc']!),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green.shade200),
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  role['icon']!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  role['title']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 40,
            right: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Tutup",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
