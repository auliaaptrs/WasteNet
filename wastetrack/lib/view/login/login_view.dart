import 'package:flutter/material.dart';
import 'package:wastetrack/common/color_extension.dart';
import 'package:wastetrack/common_widget/round_button.dart';
import 'package:wastetrack/global/banksampahprofile.dart';
import 'package:wastetrack/global/userprofile.dart';
import 'package:wastetrack/models/BankSampahProfile.dart';
import 'package:wastetrack/models/userprofile.dart';
import 'package:wastetrack/view/login/reset_password_view.dart';
import 'package:wastetrack/view/login/sign_up_view.dart';
import '../../common_widget/round_textfield.dart';
import 'package:wastetrack/view/main_tabview/main_tabview.dart';
import 'package:wastetrack/view/main_tabview/maintab_nasabah_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



final dummyNasabahMandiri = UserProfile(
  name: "Fitriana Amalia",
  id: "NSBM-25050046",
  role: "Nasabah Mandiri",
  institusi: "Mandiri",
  email: "FitrianaAmalia@gmail.com",
  phone: "08123456789",
  province: "Jawa Barat",
  city: "Bandung",
  district: "Coblong",
  subdistrict: "Dago",
  address: "Jl. Dipatiukur No. 1",
);

final dummyNasabahInstitusi = UserProfile(
  name: "Sari Wati",
  id: "NSBI-25050047",
  role: "Nasabah Institusi",
  institusi: "SD Alam Mulia",
  email: "Sariwati@gmail.com",
  phone: "08129876543",
  province: "Jawa Timur",
  city: "Surabaya",
  district: "Sukolilo",
  subdistrict: "Keputih",
  address: "Jl. Raya Keputih No. 10",
);

final dummyTPSNon3R = UserProfile(
  name: "Fikri Saputra",
  id: "TPSN-25050048",
  role: "TPS Jaya",
  email: "Fikri.tpsnon3r@gmail.com",
  phone: "08121234567",
  province: "DKI Jakarta",
  city: "Jakarta Selatan",
  district: "Kebayoran Baru",
  subdistrict: "Gandaria Selatan",
  address: "Jl. Melati No. 5",
  institusi: 'TPS Jaya',
);

final dummyTPS3R = BankSampahProfile(
  bankId: "TPSR-25050049",
  namaBank: "TPS 3R Berkah",
  namaPJ: "Dina Asri",
  telepon: "08123456789",
  alamat: "Jl. Melati No. 3",
  kelurahan: "Gandaria Selatan",
  kecamatan: "Kebayoran Baru",
  kota: "Jakarta Selatan",
  provinsi: "DKI Jakarta",
  kapasitas: 500,
);

final dummyBanksampahInduk = BankSampahProfile(
  bankId: "BNKI-25050050",
  namaBank: "Bank Sampah Surabaya",
  namaPJ: "Taufik Ismail",
  telepon: "08129876543",
  alamat: "Jl. Induk No. 1",
  kelurahan: "Keputih",
  kecamatan: "Sukolilo",
  kota: "Surabaya",
  provinsi: "Jawa Timur",
  kapasitas: 2000,
);

final dummyBanksampahUnit = BankSampahProfile(
  bankId: "BNKU-25050051",
  namaBank: "Bank Sampah Mawar",
  namaPJ: "Mawar Rahayu",
  telepon: "08121234567",
  alamat: "Jl. Mawar No. 10",
  kelurahan: "Keputih",
  kecamatan: "Sukolilo",
  kota: "Surabaya",
  provinsi: "Jawa Timur",
  kapasitas: 1000,
);

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    final email = txtEmail.text.trim();
    final password = txtPassword.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email dan password harus diisi');
      return;
    }

    try {
      //POST login
      final loginResponse = await http.post(
        Uri.parse('https://be-wastetrack-authservice-879904203531.us-central1.run.app/Users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (loginResponse.statusCode != 200) {
        try {
          final errorData = jsonDecode(loginResponse.body);
          _showMessage(errorData['error'] ?? 'Email atau password salah');
        } catch (_) {
          _showMessage('Email atau password salah');
        }
        return;
      }

      //GET user by email untuk dapat user_id
      final userByEmailResponse = await http.get(
        Uri.parse('https://be-wastetrack-authservice-879904203531.us-central1.run.app/Users/Email/$email'),
      );
      if (userByEmailResponse.statusCode != 200) {
        _showMessage('User tidak ditemukan');
        return;
      }
      final userByEmailData = jsonDecode(userByEmailResponse.body);
      final userId = userByEmailData['user_id'];

      if (userId == null) {
        _showMessage('User ID tidak ditemukan');
        return;
      }

      //GET user by ID untuk dapat role
      final userByIdResponse = await http.get(
        Uri.parse('https://be-wastetrack-authservice-879904203531.us-central1.run.app/Users/ID/$userId'),
      );
      if (userByIdResponse.statusCode != 200) {
        _showMessage('Gagal mengambil data user');
        return;
      }
      final userByIdData = jsonDecode(userByIdResponse.body);
      final role = userByIdData['role'] ?? userByIdData['Role'];

      if (role == null) {
        _showMessage('Role user tidak ditemukan');
        return;
      }

      //Assign dummy dan navigasi sesuai role
      if (role == "Nasabah Mandiri") {
        userProfile = dummyNasabahMandiri;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabNasabahView()),
        );
      } else if (role == "Nasabah Institusi") {
        userProfile = dummyNasabahInstitusi;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabNasabahView()),
        );
      } else if (role == "TPS Non-3R") {
        userProfile = dummyTPSNon3R;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabNasabahView()),
        );
      } else if (role == "TPS 3R") {
        bankSampahProfile = dummyTPS3R;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabView()),
        );
      } else if (role == "Bank Sampah Induk") {
        bankSampahProfile = dummyBanksampahInduk;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabView()),
        );
      } else if (role == "Bank Sampah Unit") {
        bankSampahProfile = dummyBanksampahUnit;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabView()),
        );
      } else {
        _showMessage('Role tidak dikenali');
      }
    } catch (e) {
      _showMessage('Terjadi kesalahan koneksi');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/login_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  Image.asset("assets/img/app_logo.png", height: 80),
                  const SizedBox(height: 10),
                  Text(
                    "Selamat Datang Kembali!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Masuk kembali untuk teruskan aksi bijakmu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildTitle("Email"),
                  RoundTextfield(
                    hintText: "nama@gmail.com",
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildTitle("Sandi"),
                  RoundTextfield(
                    hintText: "********",
                    controller: txtPassword,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  RoundButton(
                    title: "Masuk",
                    onPressed: _login,
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpView()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Daftar",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResetPasswordView()),
                      );
                    },
                    child: Text(
                      "Lupa Sandi?",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
