import 'package:flutter/material.dart';
import 'package:wastetrack/global/banksampahprofile.dart';
import 'package:wastetrack/global/userprofile.dart';
import 'package:wastetrack/view/main_tabview/main_tabview.dart';
import 'package:wastetrack/view/widget/Profile/ubah_sandi.dart';
import 'package:wastetrack/view/widget/Profile/edit_profile.dart';
import 'package:wastetrack/view/login/login_view.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Anda Yakin?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 12),
                Text(
                  'Akun Anda akan terputus dari aplikasi. Namun, Anda bisa masuk kembali kapan saja.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Batal', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginView()),
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          foregroundColor: Colors.red,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bankProfile = bankSampahProfile;
    final nasabahProfile = userProfile;

    final bool isBank = bankProfile != null;
    final String namaUtama = isBank ? bankProfile!.namaBank : (nasabahProfile?.name ?? '-');
    final String kontakUtama = isBank ? bankProfile!.telepon : (nasabahProfile?.phone ?? '-');
    final String idUtama = isBank ? bankProfile!.bankId : (nasabahProfile?.id ?? '-');
    final String roleUtama = isBank ? "Bank Sampah" : (nasabahProfile?.role ?? '-');
    final String alamatUtama = isBank
        ? '${bankProfile!.alamat}\n${bankProfile.kelurahan}, ${bankProfile.kecamatan}, ${bankProfile.kota}, ${bankProfile.provinsi}'
        : '${nasabahProfile?.address ?? '-'}\n${nasabahProfile?.subdistrict ?? ''}, ${nasabahProfile?.district ?? ''}, ${nasabahProfile?.city ?? ''}, ${nasabahProfile?.province ?? ''}';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainTabView()),
            );
          },
        ),
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 48,
                        backgroundImage: AssetImage('assets/img/splash_bg.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.edit, size: 18, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    namaUtama,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kontakUtama,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/bg_cardSmall.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(isBank ? 'Tabungan Uang' : 'ID Pengguna', style: const TextStyle(fontSize: 16, color: Colors.black)),
                          Expanded(
                            child: Text(
                              idUtama,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Text('Peran', style: const TextStyle(fontSize: 16, color: Colors.black)),
                          Expanded(
                            child: Text(
                              roleUtama,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      if (isBank) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Text('Kapasitas', style: TextStyle(fontSize: 16, color: Colors.black)),
                            Expanded(
                              child: Text(
                                '${bankProfile!.kapasitas} Kg',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            if (isBank) ...[
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Penanggung Jawab'),
                subtitle: Text(bankProfile!.namaPJ),
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Nama Lengkap'),
                subtitle: Text(nasabahProfile?.name ?? '-'),
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Alamat'),
              subtitle: Text(alamatUtama),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Ubah Sandi'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UbahSandiPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Keluar Akun'),
              onTap: () {
                showLogoutConfirmationDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Hapus Akun', style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
