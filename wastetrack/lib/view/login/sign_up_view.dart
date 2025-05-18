import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wastetrack/common/color_extension.dart';
import 'package:wastetrack/view/login/login_view.dart';
import 'package:wastetrack/view/login/regis.dart';
import 'package:wastetrack/view/login/regis_nasabah.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/round_button.dart';
import 'package:wastetrack/view/login/informasi_peran_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtSecPassword = TextEditingController();

  String? selectedPeran;
  bool obscurePassword = true;
  bool obscureSecPassword = true;
  bool isLoading = false;

  final List<String> peranList = [
    "Bank Sampah Induk",
    "Bank Sampah Unit",
    "Nasabah Mandiri",
    "Nasabah Institusi",
    "TPS 3R",
    "TPS Non 3R",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/login_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 64),
                Image.asset("assets/img/app_logo.png", height: 80),
                const SizedBox(height: 10),
                Text(
                  "Selamat Datang!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Daftar sekarang untuk teruskan aksi bijakmu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 16, bottom: 4),
                  child: const Text(
                    "Apa Peran Anda?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: TColor.textfield,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPeran,
                      hint: const Text("Pilih Peran Anda"),
                      isExpanded: true,
                      items: peranList.map((peran) {
                        return DropdownMenuItem<String>(
                          value: peran,
                          child: Text(peran),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPeran = value;
                        });
                      },
                    ),
                  ),
                ),

                // Help section
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      Icon(Icons.help_outline, size: 18, color: TColor.primary),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InformasiPeranView(),
                            ),
                          );
                        },
                        child: Text(
                          "Klik untuk memahami peran Anda",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),
                _buildTitle("Email"),
                RoundTextfield(
                  hintText: "nama@gmail.com",
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 5),
                _buildTitle("Sandi"),
                RoundTextfield(
                  hintText: "********",
                  controller: txtPassword,
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: TColor.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),

                _buildPasswordNote(),
                _buildTitle("Masukkan Ulang Sandi"),
                RoundTextfield(
                  hintText: "********",
                  controller: txtSecPassword,
                  obscureText: obscureSecPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureSecPassword ? Icons.visibility_off : Icons.visibility,
                      color: TColor.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureSecPassword = !obscureSecPassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 25),
                RoundButton(
                  title: isLoading ? "Memproses..." : "Daftar",
                  onPressed: isLoading
                      ? () {}
                      : () {
                    _handleSignUp(context);
                  },
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Masuk",
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildPasswordNote() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("• Minimal 8 karakter", style: TextStyle(color: TColor.primary, fontSize: 12)),
          Text("• Harus mengandung huruf besar dan kecil", style: TextStyle(color: TColor.primary, fontSize: 12)),
        ],
      ),
    );
  }

  void _showWarning(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Peringatan"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSignUp(BuildContext context) async {
    if (selectedPeran == null || txtEmail.text.isEmpty) {
      _showWarning("Peran dan email harus diisi!");
      return;
    }
    if (txtPassword.text.isEmpty || txtSecPassword.text.isEmpty) {
      _showWarning("Password harus diisi!");
      return;
    }
    if (txtPassword.text != txtSecPassword.text) {
      _showWarning("Password tidak sama!");
      return;
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(txtEmail.text)) {
      _showWarning("Format email tidak valid!");
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://be-wastetrack-authservice-879904203531.us-central1.run.app/Users/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": txtEmail.text.trim(),
          "password": txtPassword.text,
          "role": selectedPeran,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final userId = responseData['user_id'] ?? '';

        if (selectedPeran == "Nasabah Mandiri" || selectedPeran == "Nasabah Institusi" ) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisNasabahView(
                peran: selectedPeran!,
                email: txtEmail.text.trim(),
                userId: userId,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisView(
                peran: selectedPeran!,
                email: txtEmail.text.trim(),
                userId: userId,
              ),
            ),
          );
        }
      } else {
        _showWarning(responseData['error'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      _showWarning("Terjadi kesalahan: ${e.toString()}");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
